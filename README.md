# Monitor de conta Vale | dti

Site estático (HTML + JS) com dados editáveis no Supabase.
Leitura aberta para qualquer pessoa com o link; edição só para e-mails da tabela `editors`, com login por link mágico.

## Estrutura

- `index.html`: o sistema inteiro
- `config.js`: URL e chave anon do Supabase (preencher)
- `img/`: logo da Vale, logos WPP ES | dti, fotos dos executivos e logos dos fornecedores
- `supabase/schema.sql`: tabelas, regras de acesso, atualização ao vivo e dados atuais

## Publicação

1. **Supabase:** crie o projeto. Em SQL Editor, cole `supabase/schema.sql`, troque os e-mails da seção 6 e rode.
2. **Supabase:** em Authentication > Users, convide cada editor (Invite user).
3. **config.js:** preencha com Project URL e a chave `anon public` (Project Settings > API).
4. **GitHub:** crie um repositório privado e envie todos os arquivos desta pasta, mantendo as subpastas.
5. **Vercel:** Add New > Project, importe o repositório, Framework Preset "Other", sem comando de build, Deploy.
6. **Supabase:** em Authentication > URL Configuration, coloque a URL da Vercel em Site URL e em Redirect URLs.

## Manutenção

- **Novo editor:** inclua o e-mail na tabela `editors` (Table Editor) e convide a pessoa em Authentication > Users.
- **Trocar foto ou logo:** substitua o arquivo em `img/` com o mesmo nome e faça commit; a Vercel publica sozinha.
- **Exigir login também para ler:** no SQL Editor, troque `to anon, authenticated` por `to authenticated` na política "docs leitura publica".
