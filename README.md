# Monitor de conta Vale | dti

Site estático (HTML + JS) com dados editáveis no Supabase.
Leitura aberta para qualquer pessoa com o link; edição só para e-mails da tabela `editors`, com login por e-mail e senha.

## Estrutura

- `index.html`: o sistema inteiro
- `config.js`: URL e chave anon do Supabase (preencher)
- `img/`: logo da Vale, logos WPP ES | dti, fotos dos executivos e logos dos fornecedores
- `supabase/schema.sql`: tabelas, regras de acesso, atualização ao vivo e dados atuais

## Publicação

1. **Supabase:** crie o projeto. Em SQL Editor, cole `supabase/schema.sql`, troque os e-mails da seção 6 e rode.
2. **Supabase:** em Authentication > Users > Add user > Create new user, crie cada editor com e-mail e senha e marque Auto Confirm User. Em Authentication > Sign In / Providers, desligue "Allow new users to sign up".
3. **config.js:** preencha com o Project URL e a Publishable key (`sb_publishable_...`), que ficam no botão Connect ou em Project Settings > API Keys.
4. **GitHub:** crie um repositório privado e envie todos os arquivos desta pasta, mantendo as subpastas.
5. **Vercel:** Add New > Project, importe o repositório, Framework Preset "Other", sem comando de build, Deploy.
6. **Supabase:** em Authentication > URL Configuration, coloque a URL da Vercel em Site URL e em Redirect URLs.

## Manutenção

- **Novo editor:** crie o usuário em Authentication > Users > Add user e inclua o e-mail na tabela `editors` (Table Editor).
- **Senha esquecida:** o próprio editor usa "Esqueci minha senha" na tela de login e recebe um link para criar outra.
- **Trocar foto ou logo:** substitua o arquivo em `img/` com o mesmo nome e faça commit; a Vercel publica sozinha.
- **Foto de gestor:** salve em `img/fotos/` com o nome listado em `img/fotos/LEIA-ME.txt` (ex.: `flavio-thimotio-da-silva.jpg`).
- **LinkedIns dos gestores:** rode `supabase/linkedins-gestores.sql` uma vez no SQL Editor (pode rodar de novo sem duplicar).
- **Banco criado antes das páginas de gestores:** rode `supabase/migracao-gestores.sql` uma vez no SQL Editor.
- **Exigir login também para ler:** no SQL Editor, troque `to anon, authenticated` por `to authenticated` na política "docs leitura publica".
