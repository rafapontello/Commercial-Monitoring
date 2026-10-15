-- Rode apenas se você já executou o schema.sql ANTES da inclusão das páginas de gestores.
-- Libera a nova coleção 'mgrs' (dados editáveis de cada gestor) na tabela docs.
alter table public.docs drop constraint if exists docs_collection_check;
alter table public.docs add constraint docs_collection_check
  check (collection in ('people','dirs','account','mgrs'));
