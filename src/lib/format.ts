export const MONTHS = [
  "Janeiro",
  "Fevereiro",
  "Março",
  "Abril",
  "Maio",
  "Junho",
  "Julho",
  "Agosto",
  "Setembro",
  "Outubro",
  "Novembro",
  "Dezembro",
];

export function brl(value: number | null | undefined) {
  return (Number(value ?? 0)).toLocaleString("pt-BR", {
    style: "currency",
    currency: "BRL",
  });
}

export function pct(value: number | null | undefined, digits = 2) {
  if (value === null || value === undefined) return "—";
  return `${Number(value).toFixed(digits)}%`;
}

export function periodLabel(month: number, year: number) {
  return `${MONTHS[month - 1]}/${year}`;
}

export function quarterOf(month: number) {
  return Math.floor((month - 1) / 3) + 1;
}

export const PERIOD_STATUS_LABEL: Record<string, string> = {
  aberto: "Aberto",
  em_preenchimento: "Em preenchimento",
  enviado: "Enviado pelo gerente",
  em_conferencia: "Em conferência",
  correcao_solicitada: "Correção solicitada",
  aprovado: "Aprovado",
  fechado: "Fechado",
  pago: "Pago",
};

export function statusTone(status: string) {
  switch (status) {
    case "aprovado":
    case "pago":
      return "bg-success/10 text-success border-success/30";
    case "fechado":
      return "bg-info/10 text-info border-info/30";
    case "correcao_solicitada":
      return "bg-destructive/10 text-destructive border-destructive/30";
    case "enviado":
    case "em_conferencia":
      return "bg-warning/15 text-warning-foreground border-warning/40";
    default:
      return "bg-muted text-muted-foreground border-border";
  }
}

export function resultTone(status: string) {
  switch (status) {
    case "aprovado":
      return "bg-success/10 text-success border-success/30";
    case "eliminado":
    case "sem_bonus":
      return "bg-destructive/10 text-destructive border-destructive/30";
    case "sem_gatilho":
      return "bg-warning/15 text-warning-foreground border-warning/40";
    default:
      return "bg-muted text-muted-foreground border-border";
  }
}

export const RESULT_STATUS_LABEL: Record<string, string> = {
  pendente: "Pendente",
  aprovado: "Calculado",
  sem_gatilho: "Sem gatilho",
  eliminado: "Eliminado",
  sem_bonus: "Sem bônus",
};
