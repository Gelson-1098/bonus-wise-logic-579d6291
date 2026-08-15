import { useEffect, useState } from "react";
import { useQuery } from "@tanstack/react-query";
import type { Session } from "@supabase/supabase-js";
import { supabase } from "@/integrations/supabase/client";

export function useSession() {
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    supabase.auth.getSession().then(({ data }) => {
      if (!mounted) return;
      setSession(data.session);
      setLoading(false);
    });
    const { data: sub } = supabase.auth.onAuthStateChange((_event, s) => {
      setSession(s);
    });
    return () => {
      mounted = false;
      sub.subscription.unsubscribe();
    };
  }, []);

  return { session, loading };
}

export type AccessInfo = {
  userId: string | null;
  email: string | null;
  fullName: string | null;
  isMaster: boolean;
  storeIds: string[];
};

export function useAccess() {
  const { session } = useSession();
  const userId = session?.user.id ?? null;

  return useQuery<AccessInfo>({
    queryKey: ["access", userId],
    enabled: !!userId,
    staleTime: 60_000,
    queryFn: async () => {
      const [roles, stores, profile] = await Promise.all([
        supabase.from("user_roles").select("role").eq("user_id", userId!),
        supabase.from("user_stores").select("store_id").eq("user_id", userId!),
        supabase.from("profiles").select("full_name,email").eq("id", userId!).maybeSingle(),
      ]);
      return {
        userId,
        email: profile.data?.email ?? session?.user.email ?? null,
        fullName: profile.data?.full_name ?? null,
        isMaster: (roles.data ?? []).some((r) => r.role === "master"),
        storeIds: (stores.data ?? []).map((s) => s.store_id),
      };
    },
  });
}
