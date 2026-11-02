
# Supabase (supabase)

Local Supabase stack (Postgres, Auth, Storage, Realtime) through Docker-in-Docker, versioned SQL migrations, pgTAP tests, pre-push hook, CI/deploy workflows, Claude Code (shared login) and OpenCode.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| supabaseCliVersion | Supabase CLI version (also used by the CI workflows): | string | 2.122.0 |
| installDart | Install the Dart SDK (about 500 MB) to generate Dart types for a Flutter app (make types-dart): | boolean | false |

## Développer avec le dev container

### Ouvrir le conteneur

- **VS Code** : **Dev Containers: Reopen in Container**. Docker Desktop ou Docker dans WSL2, avec au moins 4 cœurs et 8 Go de RAM alloués.
- **Codespaces** : machine de **4 cœurs / 16 Go** minimum (`hostRequirements` impose 4 cœurs / 8 Go).

À la création, `scripts/bootstrap.sh` lance `supabase init` si `supabase/config.toml` n'existe pas, puis active les hooks git (`git config core.hooksPath .githooks`). Supabase n'est pas démarré automatiquement : au démarrage, le conteneur affiche seulement les commandes disponibles (`make help`).

### Premier démarrage

```bash
make up        # ~1 min, plusieurs minutes la première fois (téléchargement des images)
make status    # URLs et clés locales
```

| Service | URL locale |
|---|---|
| API (REST, Auth, Storage, Realtime) | http://localhost:54321 |
| Postgres | `postgresql://postgres:postgres@localhost:54322/postgres` |
| Studio | http://localhost:54323 |
| Mailpit (e-mails d'auth) | http://localhost:54324 |

Les clés locales affichées par `make status` sont publiques et identiques pour tout le monde : ne les réutilise jamais à distance.

### Boucle de travail quotidienne

```bash
make new name=add_profiles     # crée supabase/migrations/<timestamp>_add_profiles.sql
# écrire le SQL (ou prototyper dans Studio puis : make diff name=add_profiles)
make reset                     # rejoue toutes les migrations + seed.sql
make test                      # tests pgTAP (supabase/tests)
make check                     # avant chaque commit : migrations-check + reset + lint + advisors + test
make types                     # types TypeScript pour les Edge Functions
make types-dart TYPES_DART=../app/lib/supabase/database.types.dart   # types Dart pour l'app Flutter
```

`make types-dart` a besoin du SDK Dart : active l'option `installDart` du template (≈ 500 Mo), ou lance la commande depuis le dev container Flutter.

`make check` démarre la stack si elle ne tourne pas. C'est la même commande que le hook pre-push et la CI (`.github/workflows/db-ci.yml`).

Règles :
- une migration déjà présente sur `origin/main` ne se modifie jamais : on en ajoute une nouvelle (`make migrations-check` le vérifie) ;
- le schéma distant ne se modifie jamais depuis le dashboard : uniquement par migrations ;
- chaque table de `public` a RLS activée et des tests pgTAP qui figent qui peut lire et écrire (voir `supabase/tests/900_example_rls_pattern.test.sql`).

### Tester sur staging avant de pousser

Renseigne `SUPABASE_ACCESS_TOKEN`, `SUPABASE_PROJECT_ID_STAGING` et `SUPABASE_DB_PASSWORD_STAGING` : copie `.env.example` en `.env` (ignoré par git), ou utilise des secrets Codespaces (voir plus bas).

```bash
make remote-diff env=staging   # supabase link + db push --dry-run : affiche ce qui serait appliqué
make remote-push env=staging   # même chose, puis applique après avoir tapé "staging"
```

`env=prod` / `env=production` sont refusés : la prod ne se déploie que par la CI.

### Du commit à la prod

1. `git push` : le hook `.githooks/pre-push` lance `make check` si `supabase/` a changé. En urgence, `git push --no-verify` le contourne ; la CI relance de toute façon les mêmes vérifications.
2. Pull request : `db-ci.yml` lance `make check`.
3. Merge sur `main` : `db-deploy.yml` applique les nouvelles migrations sur **staging**.
4. Prod : **Actions > Database deploy > Run workflow > production**, approuvé par un relecteur de l'environnement `production`.

### Secrets

| Où | Variables |
|---|---|
| `.env` (local, ignoré par git) ou secrets Codespaces | `SUPABASE_ACCESS_TOKEN`, `SUPABASE_PROJECT_ID_STAGING`, `SUPABASE_DB_PASSWORD_STAGING` |
| GitHub > Settings > Environments > `staging` et `production` (secrets d'environnement) | `SUPABASE_ACCESS_TOKEN`, `SUPABASE_PROJECT_ID`, `SUPABASE_DB_PASSWORD` |

**Codespaces** : GitHub > Settings > Codespaces > Secrets (ou ceux du dépôt), ajoute les trois variables locales et donne accès au dépôt. Elles deviennent des variables d'environnement dans le codespace : pas besoin de `.env`, et les valeurs déjà définies ne sont pas écrasées par un `.env`.

La clé `service_role` / secrète ne va jamais dans un fichier versionné, ni dans l'app mobile : seulement dans les secrets des Edge Functions (`supabase secrets set`) ou d'un backend.

Sur l'environnement `production`, ajoute des *required reviewers* et limite les branches de déploiement à `main`. Protège `main` en exigeant le check « Database CI ».

### Dépannage

- **Docker-in-Docker lent** : le premier `make up` télécharge environ 3 Go d'images. Elles restent dans le volume `/var/lib/docker` du conteneur (survit aux redémarrages, pas à un rebuild sans cache de volume). Pour aller plus vite : `make up EXCLUDE=studio,imgproxy,logflare,vector`.
- **Ports déjà pris** (54321–54324) : une autre stack Supabase tourne (`supabase stop --project-id <id>`, ou `docker ps` sur l'hôte). Sinon, change les ports dans `supabase/config.toml`.
- **Tout réinitialiser** : `supabase stop --no-backup` supprime les volumes de données locaux, puis `make up`.
- **Mettre à jour la CLI** : change `SUPABASE_CLI_VERSION` dans `.devcontainer/devcontainer.json` (build arg) et dans `.github/workflows/db-*.yml`, puis **Rebuild Container**. `scripts/agent-check.sh` signale un écart entre les deux.
- **`make check` échoue sur `advisors`** : lis le message de l'advisor (lien vers la doc Supabase). Corrige le schéma par une nouvelle migration plutôt que d'abaisser le niveau.

## Sécurité du conteneur

La feature docker-in-docker exige un conteneur **privilégié** : contrairement aux autres templates, celui-ci ne peut pas utiliser `--cap-drop=ALL` / `no-new-privileges`. Le daemon Docker interne est isolé de celui de l'hôte, mais un conteneur privilégié peut agir sur l'hôte. N'y exécute que du code de confiance.

## Claude Code login

The `ai-tools` feature mounts the named volume `claude-code-config` and sets `CLAUDE_CONFIG_DIR`. Log in once with `claude`: every container built from these templates reuses the same login and user settings. Do not add another Claude mount or `CLAUDE_CONFIG_DIR` in `devcontainer.json`, it would override the shared one.


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/lucassoumaille/devcontainer-templates/blob/main/src/supabase/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
