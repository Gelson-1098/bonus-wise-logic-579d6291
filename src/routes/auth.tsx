import { createFileRoute } from "@tanstack/react-router";
import { LoginCard } from "@/components/login-card";

export const Route = createFileRoute("/auth")({
  head: () => ({
    meta: [
      { title: "Entrar | DEX BONUS" },
      {
        name: "description",
        content: "Acesse o DEX BONUS para lançar, conferir e aprovar a bonificação das lojas DEX Invest.",
      },
      { property: "og:title", content: "Entrar | DEX BONUS" },
      { property: "og:description", content: "Acesso ao sistema de gestão de bônus da DEX Invest." },
      { property: "og:type", content: "website" },
      { name: "twitter:card", content: "summary" },
    ],
  }),
  component: AuthPage,
});

function AuthPage() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-secondary/50 px-4 py-12">
      <LoginCard />
    </div>
  );
}
