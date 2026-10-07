-- =====================================================================
-- Monitor de conta Vale | dti
-- Rode este arquivo inteiro no Supabase: SQL Editor > New query > Run
-- =====================================================================

-- 1. Tabelas -----------------------------------------------------------

-- Lista de quem pode editar (e-mails em minúsculas)
create table if not exists public.editors (
  email text primary key check (email = lower(email))
);

-- Dados editáveis do sistema, um documento por item
--   collection 'people'  -> id da pessoa   (LinkedIn)
--   collection 'dirs'    -> id da diretoria (farol, reuniões, ações, melhorias)
--   collection 'account' -> id 'dti'        (battle card dti)
create table if not exists public.docs (
  collection text not null check (collection in ('people','dirs','account')),
  id         text not null,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by text,
  primary key (collection, id)
);

-- 2. Registro automático de quem editou e quando -----------------------
create or replace function public.docs_stamp() returns trigger
language plpgsql as $$
begin
  new.updated_at := now();
  new.updated_by := lower(auth.jwt() ->> 'email');
  return new;
end $$;

drop trigger if exists docs_stamp on public.docs;
create trigger docs_stamp before insert or update on public.docs
for each row execute function public.docs_stamp();

-- 3. Segurança (RLS) ----------------------------------------------------
alter table public.docs    enable row level security;
alter table public.editors enable row level security;

create or replace function public.is_editor() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.editors e where e.email = lower(auth.jwt() ->> 'email'));
$$;

drop policy if exists "docs leitura publica"   on public.docs;
drop policy if exists "docs editores inserem"   on public.docs;
drop policy if exists "docs editores atualizam" on public.docs;
drop policy if exists "editors ve o proprio"    on public.editors;

-- Qualquer pessoa (inclusive sem login) pode LER
create policy "docs leitura publica" on public.docs
  for select to anon, authenticated using (true);

-- Só quem está na lista de editores pode GRAVAR
create policy "docs editores inserem" on public.docs
  for insert to authenticated with check (public.is_editor());
create policy "docs editores atualizam" on public.docs
  for update to authenticated using (public.is_editor()) with check (public.is_editor());

-- Cada pessoa logada só enxerga a própria linha na lista de editores
create policy "editors ve o proprio" on public.editors
  for select to authenticated using (email = lower(auth.jwt() ->> 'email'));

-- 4. Atualização ao vivo para todos os visitantes ----------------------
do $$ begin
  alter publication supabase_realtime add table public.docs;
exception when duplicate_object then null; end $$;

-- 5. Dados atuais (migrados do sistema anterior) -----------------------
insert into public.docs (collection, id, data) values
  ('people','bittar',    '{"linkedin":"https://www.linkedin.com/in/rafael-jabur-bittar-84603224/"}'),
  ('people','paulo',     '{"linkedin":"https://www.linkedin.com/in/paulo-pires2018/"}'),
  ('people','helio',     '{"linkedin":"https://www.linkedin.com/in/heliomosquim/"}'),
  ('people','fabio',     '{"linkedin":"https://www.linkedin.com/in/fabio-eugenio-souza-0a11914/"}'),
  ('people','carlos',    '{"linkedin":"https://www.linkedin.com/in/carlos-eduardo-boechat-industria-tecnologia-transformacao-digital-inovacao-engenharia/"}'),
  ('people','claudia',   '{"linkedin":"https://www.linkedin.com/in/claudia-gomes-cabaline-mazzi-392a392ab/"}'),
  ('people','gilson',    '{"linkedin":"https://www.linkedin.com/in/gilson-santana-795045101/"}'),
  ('people','patrice',   '{"linkedin":"https://www.linkedin.com/in/patrice-mazzoni/"}'),
  ('people','alexandre', '{"linkedin":"https://www.linkedin.com/in/pigatti/"}'),
  ('people','dan',       '{"linkedin":"https://www.linkedin.com/in/dan-harif-331a98/"}'),
  ('dirs','helio',       '{"farolDir":"forte"}')
on conflict (collection, id) do nothing;

-- 6. Editores ------------------------------------------------------------
-- Troque pelos e-mails reais (sempre em minúsculas) e rode esta parte de novo
-- sempre que quiser incluir alguém.
insert into public.editors (email) values
  ('rafaela.pontello@dtidigital.com.br')('ramon.finelli@dtidigital.com.br')
on conflict do nothing;
