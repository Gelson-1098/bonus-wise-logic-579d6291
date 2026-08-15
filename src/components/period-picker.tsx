import { MONTHS } from "@/lib/format";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";

export function PeriodPicker({
  month,
  year,
  onChange,
}: {
  month: number;
  year: number;
  onChange: (v: { month: number; year: number }) => void;
}) {
  const nowYear = new Date().getFullYear();
  const years = [nowYear - 1, nowYear, nowYear + 1];
  return (
    <div className="flex items-center gap-2">
      <Select value={String(month)} onValueChange={(v) => onChange({ month: Number(v), year })}>
        <SelectTrigger className="w-[150px]">
          <SelectValue />
        </SelectTrigger>
        <SelectContent>
          {MONTHS.map((m, i) => (
            <SelectItem key={m} value={String(i + 1)}>
              {m}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
      <Select value={String(year)} onValueChange={(v) => onChange({ month, year: Number(v) })}>
        <SelectTrigger className="w-[100px]">
          <SelectValue />
        </SelectTrigger>
        <SelectContent>
          {years.map((y) => (
            <SelectItem key={y} value={String(y)}>
              {y}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
    </div>
  );
}
