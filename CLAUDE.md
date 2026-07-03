# CLAUDE.md — Our Life Abroad

## Projet
Blog de voyage bilingue (couple en slow travel Amérique du Sud / Asie). Objectif : monétisation via liens affiliés (SIM/eSIM, cartes de paiement, booking, Airbnb, Amazon...).
- **Domaine live** : https://ourlifeabroad.crea-dapp.com
- **GitHub** : rs-our-life-abroad/ourlifeabroad (le repo a été transféré depuis `coding-training-pers/ourlifeabroad` — remote git local mis à jour le 2 juillet 2026, `admin/config.yml` du CMS pointait déjà vers la bonne adresse)
- **Dossier local** : ~/ourlifeabroad-temp/
- **Branche active** : main

## Accès / comptes
- Utiliser le compte GitHub **`creadapp`** pour push (celui utilisé sur les vrais projets business). Un second compte `coding-training-pers` est aussi connecté sur cette machine mais c'est l'identité legacy — ne pas l'utiliser pour éviter de perpétuer la confusion entre deux identités.
- `creadapp` a le scope OAuth `workflow` (ajouté le 2 juillet 2026 via `gh auth refresh -h github.com -s workflow`) — nécessaire pour pousser des modifications dans `.github/workflows/`. Sans ce scope, le push est rejeté par GitHub.

## Stack
- Jekyll 4.3 (gem `jekyll` directement, plus de gem `github-pages`) — Ruby 3.3.0 (`.ruby-version`)
- Plugins : `jekyll-feed`, `jekyll-seo-tag`, `jekyll-sitemap`
- Build/déploiement : **Coolify** — `Dockerfile` (build Jekyll → nginx alpine) + `nginx.conf`, sur l'infra crea-dapp (VPS Hetzner). Ce projet est bien sur l'infra commune.
- `baseurl: ""` — **pas de préfixe `/ourlifeabroad/`** dans les chemins. Ne jamais coder un chemin en dur avec ce préfixe (c'était le cas avant la migration GitHub Pages → Coolify de mai 2026).
- Contenu géré via **Decap CMS** (`/admin`), OAuth via Cloudflare Worker (`ourlifeabroad-oauth.coding-training-pers.workers.dev`)
- Déploiement : push sur `main` → build/déploiement Coolify (auto-deploy pas formellement confirmé, à vérifier côté dashboard Coolify)
- Thème CSS maison "scrapbook" (`assets/css/scrapbook.css`)
- i18n manuelle : dossiers `fr/` et `en/`, front matter `lang:`, pas de plugin i18n
- Layouts : `default`, `destination`, `index`, `redirect`, `post` — pas de layout `page` (le fichier racine `about.markdown` qui le référence est orphelin/legacy, non lié depuis la nav ; les vraies pages "about" sont `fr/about.md` et `en/about.md` en `layout: default`)

## Leçon retenue — toujours vérifier l'état réel du remote
`git status` affiche "up to date with origin/main" à partir du dernier `fetch` local, **pas** d'une vérification live. Ce dossier est resté figé un mois sur une architecture obsolète (GitHub Pages) sans que rien ne l'indique en début de session. **Toujours faire `git fetch origin main` explicitement avant de commencer à travailler.**

## Monétisation — règles spécifiques
- **Disclosure obligatoire** : tout article contenant un lien affilié doit mentionner clairement "cet article contient des liens affiliés" (obligation légale France/UE). Exemple en place : `fr/guides/internet-esim.md` / `en/guides/internet-esim.md`.
- **Couche de redirection `/go/`** : ne jamais mettre une URL affiliée brute dans un article. Créer une entrée dans la collection `_redirects/` (front matter `permalink`, `target`, `title`, `umami_event`) puis lier vers `/go/<slug>/` dans le contenu (sans préfixe, `baseurl` est vide). Avantage : un seul endroit à modifier si une URL de tracking change.
  - Exemple en place : `_redirects/sim.md` → `/go/sim/` → MySim4Trip (comparateur SIM/eSIM, projet crea-dapp séparé), utilisé depuis le guide `internet-esim`.
  - Layout : `_layouts/redirect.html` (meta-refresh + lien de secours + event Umami + `rel="sponsored nofollow noopener"` par défaut).
- **Jamais de clé/API d'affiliation en clair** committée — ce repo est public sur GitHub.

## Analytics (Umami)
- `_config.yml` → `umami_website_id` : vide tant que le site n'est pas ajouté au dashboard `stats.crea-dapp.com`.
- Une fois l'ID obtenu (créer le site dans Umami), le coller dans `_config.yml` : le script s'active automatiquement dans `_layouts/default.html`.
- Les clics `/go/...` envoient un event Umami (`umami_event` défini par redirection).

## Vérification des liens (CI — `.github/workflows/link-check.yml`)
- Build Jekyll 4.3 classique (`bundle exec jekyll build`, Ruby 3.3.0) + `html-proofer`, déclenché sur chaque push `main` + cron hebdomadaire (lundi 6h UTC).
- **CI verte au 2 juillet 2026** (contenu complet écrit — voir `progress.md`).
- CLI html-proofer v5 : le chemin à vérifier doit être le **dernier argument** (les options listes sont gourmandes et avalent sinon le chemin suivant) ; utiliser `--option=valeur` plutôt que `--option valeur` pour les options à liste.
- **`--ignore-status-codes="429"`** : Instagram (et probablement d'autres réseaux sociaux/partenaires) renvoie 429 aux IP des runners GitHub Actions par mesure anti-bot, alors que le même lien répond 200 depuis une IP résidentielle — testé et confirmé le 2 juillet 2026. Un `--ignore-urls` ciblant le domaine s'est révélé peu fiable (le lien réapparaissait quand même en échec) ; ignorer le code 429 directement est plus robuste et couvre aussi les futurs domaines partenaires (booking, airbnb, amazon...) qui bloqueraient le bot pareil.
- **Toujours tester en local ET vérifier le run réel sur GitHub** (`gh run list`/`gh run view`) après un push touchant la CI — un test local vert ne garantit pas un run GitHub vert (IP différente, comportement anti-bot différent).
- Si un domaine renvoie un vrai 403/404 (pas un simple rate-limit), l'ajouter via `--ignore-urls` plutôt que d'élargir `--ignore-status-codes`.

## Règles de validation
Agir directement sans confirmation pour : lire/analyser, créer/modifier des fichiers, créer des articles/destinations/guides, commandes git non destructives (status, log, add, commit, push) — **après un `git fetch origin main` systématique en début de session**.

Demander confirmation avant de push pour : toute modification de la **table de redirection `_redirects/`** (un ID affilié erroné est une perte de revenu silencieuse — aucun test automatique ne peut la détecter, contrairement à un lien cassé).

Demander confirmation dans tous les cas pour : suppression de fichier/repo, actions irréversibles, `git reset --hard` ou toute réécriture d'historique, changement de compte/identité GitHub actif.

## Fin de session
Avant de terminer une session : mettre à jour `progress.md` (ce projet) et, si l'état global a changé, l'entrée correspondante dans `~/structure-crea-dapp/etat-projets.md`.
