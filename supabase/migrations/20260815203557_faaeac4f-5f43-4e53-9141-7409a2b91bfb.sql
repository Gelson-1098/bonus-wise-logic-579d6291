-- ENUMS
CREATE TYPE public.app_role AS ENUM ('master','gerente');
CREATE TYPE public.period_status AS ENUM ('aberto','em_preenchimento','enviado','em_conferencia','correcao_solicitada','aprovado','fechado','pago');
CREATE TYPE public.criterion_status AS ENUM ('atingiu','nao_atingiu','nao_aplicavel');
CREATE TYPE public.version_status AS ENUM ('rascunho','publicada','arquivada');

-- UTIL
CREATE OR REPLACE FUNCTION public.update_updated_at_column() RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END; $$ LANGUAGE plpgsql SET search_path = public;

-- PROFILES
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  full_name TEXT,
  email TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles TO authenticated;
GRANT ALL ON public.profiles TO service_role;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users ON DELETE CASCADE,
  role public.app_role NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, role)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.user_roles TO authenticated;
GRANT ALL ON public.user_roles TO service_role;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION public.has_role(_user_id UUID, _role public.app_role)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role);
$$;

CREATE OR REPLACE FUNCTION public.is_master() RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT public.has_role(auth.uid(), 'master');
$$;

-- STORES
CREATE TABLE public.stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  code TEXT,
  city TEXT,
  state TEXT,
  cnpj TEXT,
  email TEXT,
  active BOOLEAN NOT NULL DEFAULT true,
  started_at DATE,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.stores TO authenticated;
GRANT ALL ON public.stores TO service_role;
ALTER TABLE public.stores ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.user_stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users ON DELETE CASCADE,
  store_id UUID NOT NULL REFERENCES public.stores ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, store_id)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.user_stores TO authenticated;
GRANT ALL ON public.user_stores TO service_role;
ALTER TABLE public.user_stores ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION public.can_access_store(_store_id UUID) RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT public.has_role(auth.uid(), 'master')
    OR EXISTS (SELECT 1 FROM public.user_stores us WHERE us.user_id = auth.uid() AND us.store_id = _store_id);
$$;

-- POSITIONS
CREATE TABLE public.positions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  group_name TEXT,
  description TEXT,
  base_value NUMERIC(12,2),
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.positions TO authenticated;
GRANT ALL ON public.positions TO service_role;
ALTER TABLE public.positions ENABLE ROW LEVEL SECURITY;

-- EMPLOYEES
CREATE TABLE public.employees (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name TEXT NOT NULL,
  cpf TEXT,
  registration TEXT,
  position_id UUID REFERENCES public.positions ON DELETE SET NULL,
  store_id UUID NOT NULL REFERENCES public.stores ON DELETE RESTRICT,
  hired_at DATE,
  terminated_at DATE,
  email TEXT,
  phone TEXT,
  active BOOLEAN NOT NULL DEFAULT true,
  bonus_eligible BOOLEAN NOT NULL DEFAULT true,
  ineligibility_reason TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.employees TO authenticated;
GRANT ALL ON public.employees TO service_role;
ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;

-- RULE VERSIONS / CRITERIA
CREATE TABLE public.bonus_rule_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  year INT NOT NULL,
  quarter INT NOT NULL,
  status public.version_status NOT NULL DEFAULT 'rascunho',
  starts_on DATE,
  ends_on DATE,
  min_trigger_pct NUMERIC(6,2) NOT NULL DEFAULT 90,
  alert_pct NUMERIC(6,2) NOT NULL DEFAULT 95,
  target_pct NUMERIC(6,2) NOT NULL DEFAULT 100,
  notes TEXT,
  created_by UUID,
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.bonus_rule_versions TO authenticated;
GRANT ALL ON public.bonus_rule_versions TO service_role;
ALTER TABLE public.bonus_rule_versions ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.bonus_criteria (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  version_id UUID NOT NULL REFERENCES public.bonus_rule_versions ON DELETE CASCADE,
  position_id UUID REFERENCES public.positions ON DELETE CASCADE,
  code TEXT,
  name TEXT NOT NULL,
  category TEXT,
  description TEXT,
  metric_type TEXT NOT NULL DEFAULT 'percentual',
  unit TEXT,
  comparator TEXT,
  target_value NUMERIC(14,4),
  target_text TEXT,
  weight_pct NUMERIC(6,2),
  value_brl NUMERIC(12,2),
  is_eliminatory BOOLEAN NOT NULL DEFAULT false,
  eliminatory_action TEXT,
  is_required BOOLEAN NOT NULL DEFAULT false,
  requires_justification BOOLEAN NOT NULL DEFAULT false,
  active BOOLEAN NOT NULL DEFAULT true,
  sort_order INT NOT NULL DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.bonus_criteria TO authenticated;
GRANT ALL ON public.bonus_criteria TO service_role;
ALTER TABLE public.bonus_criteria ENABLE ROW LEVEL SECURITY;

-- PERIODS
CREATE TABLE public.bonus_periods (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES public.stores ON DELETE CASCADE,
  year INT NOT NULL,
  month INT NOT NULL,
  quarter INT GENERATED ALWAYS AS (((month - 1) / 3) + 1) STORED,
  status public.period_status NOT NULL DEFAULT 'aberto',
  version_id UUID REFERENCES public.bonus_rule_versions ON DELETE SET NULL,
  submitted_at TIMESTAMPTZ, submitted_by UUID,
  reviewed_at TIMESTAMPTZ, reviewed_by UUID,
  review_note TEXT,
  closed_at TIMESTAMPTZ, closed_by UUID,
  reopened_at TIMESTAMPTZ, reopened_by UUID, reopen_reason TEXT,
  paid_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (store_id, year, month)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.bonus_periods TO authenticated;
GRANT ALL ON public.bonus_periods TO service_role;
ALTER TABLE public.bonus_periods ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.store_targets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  period_id UUID NOT NULL REFERENCES public.bonus_periods ON DELETE CASCADE UNIQUE,
  base_history NUMERIC(14,2),
  growth_pct NUMERIC(6,2),
  target_calculated NUMERIC(14,2),
  target_adjusted NUMERIC(14,2),
  revenue_actual NUMERIC(14,2),
  updated_by UUID,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.store_targets TO authenticated;
GRANT ALL ON public.store_targets TO service_role;
ALTER TABLE public.store_targets ENABLE ROW LEVEL SECURITY;

-- ENTRIES
CREATE TABLE public.employee_period_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  period_id UUID NOT NULL REFERENCES public.bonus_periods ON DELETE CASCADE,
  employee_id UUID NOT NULL REFERENCES public.employees ON DELETE CASCADE,
  store_id UUID NOT NULL REFERENCES public.stores ON DELETE CASCADE,
  position_id UUID REFERENCES public.positions ON DELETE SET NULL,
  base_value NUMERIC(12,2),
  calculated_value NUMERIC(12,2) NOT NULL DEFAULT 0,
  approved_value NUMERIC(12,2),
  result_status TEXT NOT NULL DEFAULT 'pendente',
  no_bonus BOOLEAN NOT NULL DEFAULT false,
  no_bonus_reason TEXT,
  notes TEXT,
  calc_snapshot JSONB,
  calculated_at TIMESTAMPTZ,
  calculated_by UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (period_id, employee_id)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.employee_period_entries TO authenticated;
GRANT ALL ON public.employee_period_entries TO service_role;
ALTER TABLE public.employee_period_entries ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.employee_criterion_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entry_id UUID NOT NULL REFERENCES public.employee_period_entries ON DELETE CASCADE,
  criterion_id UUID NOT NULL REFERENCES public.bonus_criteria ON DELETE CASCADE,
  result_value NUMERIC(14,4),
  status public.criterion_status NOT NULL DEFAULT 'nao_aplicavel',
  value_awarded NUMERIC(12,2) NOT NULL DEFAULT 0,
  note TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (entry_id, criterion_id)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.employee_criterion_results TO authenticated;
GRANT ALL ON public.employee_criterion_results TO service_role;
ALTER TABLE public.employee_criterion_results ENABLE ROW LEVEL SECURITY;

-- AUDIT
CREATE TABLE public.audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID,
  user_email TEXT,
  action TEXT NOT NULL,
  entity TEXT,
  entity_id UUID,
  store_id UUID,
  period_id UUID,
  field TEXT,
  old_value TEXT,
  new_value TEXT,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT ON public.audit_logs TO authenticated;
GRANT ALL ON public.audit_logs TO service_role;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

-- FUTURE MODULES
CREATE TABLE public.store_evaluations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES public.stores ON DELETE CASCADE,
  eval_date DATE NOT NULL,
  score NUMERIC(5,2),
  scores JSONB,
  created_by UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE public.store_feedback (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES public.stores ON DELETE CASCADE,
  feedback_date DATE NOT NULL,
  feedback TEXT,
  action_plan TEXT,
  due_date DATE,
  status TEXT,
  created_by UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE public.benefits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id UUID NOT NULL REFERENCES public.employees ON DELETE CASCADE,
  store_id UUID REFERENCES public.stores ON DELETE CASCADE,
  competence DATE,
  benefit_type TEXT,
  value NUMERIC(12,2),
  employee_discount NUMERIC(12,2),
  company_value NUMERIC(12,2),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE public.trainings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id UUID NOT NULL REFERENCES public.employees ON DELETE CASCADE,
  store_id UUID REFERENCES public.stores ON DELETE CASCADE,
  training_name TEXT,
  training_date DATE,
  instructor TEXT,
  status TEXT,
  score NUMERIC(5,2),
  notes TEXT,
  next_training DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE public.secullum_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id UUID REFERENCES public.employees ON DELETE CASCADE,
  store_id UUID REFERENCES public.stores ON DELETE CASCADE,
  record_date DATE,
  record_type TEXT,
  quantity NUMERIC(10,2),
  payload JSONB,
  imported_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.store_evaluations, public.store_feedback, public.benefits, public.trainings, public.secullum_records TO authenticated;
GRANT ALL ON public.store_evaluations, public.store_feedback, public.benefits, public.trainings, public.secullum_records TO service_role;
ALTER TABLE public.store_evaluations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.store_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.benefits ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trainings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.secullum_records ENABLE ROW LEVEL SECURITY;

-- POLICIES
CREATE POLICY "own profile read" ON public.profiles FOR SELECT TO authenticated USING (id = auth.uid() OR public.is_master());
CREATE POLICY "own profile write" ON public.profiles FOR UPDATE TO authenticated USING (id = auth.uid() OR public.is_master());
CREATE POLICY "master insert profile" ON public.profiles FOR INSERT TO authenticated WITH CHECK (id = auth.uid() OR public.is_master());

CREATE POLICY "roles read" ON public.user_roles FOR SELECT TO authenticated USING (user_id = auth.uid() OR public.is_master());
CREATE POLICY "roles master manage" ON public.user_roles FOR ALL TO authenticated USING (public.is_master()) WITH CHECK (public.is_master());

CREATE POLICY "stores read" ON public.stores FOR SELECT TO authenticated USING (true);
CREATE POLICY "stores master manage" ON public.stores FOR ALL TO authenticated USING (public.is_master()) WITH CHECK (public.is_master());

CREATE POLICY "user_stores read" ON public.user_stores FOR SELECT TO authenticated USING (user_id = auth.uid() OR public.is_master());
CREATE POLICY "user_stores master manage" ON public.user_stores FOR ALL TO authenticated USING (public.is_master()) WITH CHECK (public.is_master());

CREATE POLICY "positions read" ON public.positions FOR SELECT TO authenticated USING (true);
CREATE POLICY "positions master manage" ON public.positions FOR ALL TO authenticated USING (public.is_master()) WITH CHECK (public.is_master());

CREATE POLICY "employees read" ON public.employees FOR SELECT TO authenticated USING (public.can_access_store(store_id));
CREATE POLICY "employees insert" ON public.employees FOR INSERT TO authenticated WITH CHECK (public.can_access_store(store_id));
CREATE POLICY "employees update" ON public.employees FOR UPDATE TO authenticated USING (public.can_access_store(store_id)) WITH CHECK (public.can_access_store(store_id));
CREATE POLICY "employees delete" ON public.employees FOR DELETE TO authenticated USING (public.is_master());

CREATE POLICY "versions read" ON public.bonus_rule_versions FOR SELECT TO authenticated USING (true);
CREATE POLICY "versions master manage" ON public.bonus_rule_versions FOR ALL TO authenticated USING (public.is_master()) WITH CHECK (public.is_master());

CREATE POLICY "criteria read" ON public.bonus_criteria FOR SELECT TO authenticated USING (true);
CREATE POLICY "criteria master manage" ON public.bonus_criteria FOR ALL TO authenticated USING (public.is_master()) WITH CHECK (public.is_master());

CREATE POLICY "periods read" ON public.bonus_periods FOR SELECT TO authenticated USING (public.can_access_store(store_id));
CREATE POLICY "periods insert" ON public.bonus_periods FOR INSERT TO authenticated WITH CHECK (public.can_access_store(store_id));
CREATE POLICY "periods update" ON public.bonus_periods FOR UPDATE TO authenticated USING (public.can_access_store(store_id)) WITH CHECK (public.can_access_store(store_id));
CREATE POLICY "periods delete" ON public.bonus_periods FOR DELETE TO authenticated USING (public.is_master());

CREATE POLICY "targets read" ON public.store_targets FOR SELECT TO authenticated USING (EXISTS (SELECT 1 FROM public.bonus_periods p WHERE p.id = period_id AND public.can_access_store(p.store_id)));
CREATE POLICY "targets write" ON public.store_targets FOR ALL TO authenticated USING (EXISTS (SELECT 1 FROM public.bonus_periods p WHERE p.id = period_id AND public.can_access_store(p.store_id))) WITH CHECK (EXISTS (SELECT 1 FROM public.bonus_periods p WHERE p.id = period_id AND public.can_access_store(p.store_id)));

CREATE POLICY "entries read" ON public.employee_period_entries FOR SELECT TO authenticated USING (public.can_access_store(store_id));
CREATE POLICY "entries write" ON public.employee_period_entries FOR ALL TO authenticated USING (public.can_access_store(store_id)) WITH CHECK (public.can_access_store(store_id));

CREATE POLICY "criterion results read" ON public.employee_criterion_results FOR SELECT TO authenticated USING (EXISTS (SELECT 1 FROM public.employee_period_entries e WHERE e.id = entry_id AND public.can_access_store(e.store_id)));
CREATE POLICY "criterion results write" ON public.employee_criterion_results FOR ALL TO authenticated USING (EXISTS (SELECT 1 FROM public.employee_period_entries e WHERE e.id = entry_id AND public.can_access_store(e.store_id))) WITH CHECK (EXISTS (SELECT 1 FROM public.employee_period_entries e WHERE e.id = entry_id AND public.can_access_store(e.store_id)));

CREATE POLICY "audit read" ON public.audit_logs FOR SELECT TO authenticated USING (public.is_master() OR (store_id IS NOT NULL AND public.can_access_store(store_id)));
CREATE POLICY "audit insert" ON public.audit_logs FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());

CREATE POLICY "evals access" ON public.store_evaluations FOR ALL TO authenticated USING (public.can_access_store(store_id)) WITH CHECK (public.is_master());
CREATE POLICY "feedback access" ON public.store_feedback FOR ALL TO authenticated USING (public.can_access_store(store_id)) WITH CHECK (public.is_master());
CREATE POLICY "benefits access" ON public.benefits FOR ALL TO authenticated USING (public.is_master()) WITH CHECK (public.is_master());
CREATE POLICY "trainings access" ON public.trainings FOR ALL TO authenticated USING (public.is_master()) WITH CHECK (public.is_master());
CREATE POLICY "secullum access" ON public.secullum_records FOR ALL TO authenticated USING (public.is_master()) WITH CHECK (public.is_master());

-- SIGNUP TRIGGER: first user becomes master
CREATE OR REPLACE FUNCTION public.handle_new_user() RETURNS TRIGGER
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE user_count INT;
BEGIN
  INSERT INTO public.profiles (id, full_name, email)
  VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email), NEW.email)
  ON CONFLICT (id) DO NOTHING;
  SELECT count(*) INTO user_count FROM public.user_roles;
  IF user_count = 0 THEN
    INSERT INTO public.user_roles (user_id, role) VALUES (NEW.id, 'master');
  ELSE
    INSERT INTO public.user_roles (user_id, role) VALUES (NEW.id, 'gerente') ON CONFLICT DO NOTHING;
  END IF;
  RETURN NEW;
END; $$;
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- updated_at triggers
CREATE TRIGGER t1 BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER t2 BEFORE UPDATE ON public.stores FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER t3 BEFORE UPDATE ON public.positions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER t4 BEFORE UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER t5 BEFORE UPDATE ON public.bonus_rule_versions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER t6 BEFORE UPDATE ON public.bonus_criteria FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER t7 BEFORE UPDATE ON public.bonus_periods FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER t8 BEFORE UPDATE ON public.store_targets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER t9 BEFORE UPDATE ON public.employee_period_entries FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER t10 BEFORE UPDATE ON public.employee_criterion_results FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- SEED: stores
INSERT INTO public.stores (name, code, city, state) VALUES
 ('Vila Clementino','VCL','São Paulo','SP'),
 ('Parque Mandaqui','PMQ','São Paulo','SP'),
 ('Jabaquara','JBQ','São Paulo','SP'),
 ('Aclimação','ACL','São Paulo','SP'),
 ('Praia do Canto','PDC','Vitória','ES'),
 ('Jardim Camburi','JCB','Vitória','ES'),
 ('Guarulhos Gopoúva','GGP','Guarulhos','SP'),
 ('Pinheiros','PNH','São Paulo','SP'),
 ('Campo Belo','CBL','São Paulo','SP'),
 ('Serra','SRR','Serra','ES'),
 ('Aeroporto GRU','GRU','Guarulhos','SP'),
 ('Spoleto Jabaquara','SPJ','São Paulo','SP'),
 ('Boali','BOA',NULL,NULL);

-- SEED: positions
INSERT INTO public.positions (name, group_name, base_value, description) VALUES
 ('Operador','Operacional',400,'Valor base editável — referência do briefing'),
 ('Operador I','Operacional',400,'Cargo conforme planilha de regras'),
 ('Operador II','Operacional',400,'Cargo conforme planilha de regras'),
 ('Instrutor III','Operacional',400,'Cargo conforme planilha de regras'),
 ('Gerente Trainee','Liderança',500,'Valor base editável — referência do briefing'),
 ('Gerente Jr','Liderança',600,'Cargo conforme planilha de regras'),
 ('Gerente Pleno II','Liderança',600,'Cargo conforme planilha de regras'),
 ('Gerente Pleno III','Liderança',600,'Cargo conforme planilha de regras'),
 ('Gerente Sênior','Liderança',600,'Cargo conforme planilha de regras'),
 ('Gerente PJ','Liderança',600,'Cargo conforme planilha de regras'),
 ('Gerente','Liderança',600,'Valor base editável — referência do briefing');