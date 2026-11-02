
# Supabase (supabase)

Local Supabase stack (Postgres, Auth, Storage, Realtime) through Docker-in-Docker, versioned SQL migrations, pgTAP tests, pre-push hook, CI/deploy workflows, Claude Code (shared login) and OpenCode.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| supabaseCliVersion | Supabase CLI version (also used by the CI workflows): | string | 2.122.0 |
| installDart | Install the Dart SDK (about 500 MB) to generate Dart types for a Flutter app (make types-dart): | boolean | false |

See [NOTES.md](NOTES.md) for the daily workflow (« Développer avec le dev container »).

---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/lucassoumaille/devcontainer-templates/blob/main/src/supabase/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
