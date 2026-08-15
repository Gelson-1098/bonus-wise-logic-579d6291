-- 1. Align store_evaluations / store_feedback read vs write scopes
DROP POLICY IF EXISTS "evals access" ON public.store_evaluations;
DROP POLICY IF EXISTS "feedback access" ON public.store_feedback;

CREATE POLICY "evals select" ON public.store_evaluations
  FOR SELECT TO authenticated USING (public.can_access_store(store_id));
CREATE POLICY "evals insert master" ON public.store_evaluations
  FOR INSERT TO authenticated WITH CHECK (public.is_master());
CREATE POLICY "evals update master" ON public.store_evaluations
  FOR UPDATE TO authenticated USING (public.is_master()) WITH CHECK (public.is_master());
CREATE POLICY "evals delete master" ON public.store_evaluations
  FOR DELETE TO authenticated USING (public.is_master());

CREATE POLICY "feedback select" ON public.store_feedback
  FOR SELECT TO authenticated USING (public.can_access_store(store_id));
CREATE POLICY "feedback insert master" ON public.store_feedback
  FOR INSERT TO authenticated WITH CHECK (public.is_master());
CREATE POLICY "feedback update master" ON public.store_feedback
  FOR UPDATE TO authenticated USING (public.is_master()) WITH CHECK (public.is_master());
CREATE POLICY "feedback delete master" ON public.store_feedback
  FOR DELETE TO authenticated USING (public.is_master());

-- 2. has_role takes an arbitrary user id: not callable directly by clients anymore.
-- It is still used inside SECURITY DEFINER helpers (is_master, can_access_store) and policies,
-- which execute it as the function owner.
REVOKE EXECUTE ON FUNCTION public.has_role(uuid, public.app_role) FROM authenticated, anon, PUBLIC;
