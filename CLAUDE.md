# CLAUDE.md — Our Life Abroad

## Projet
Blog de voyage bilingue (couple en slow travel Amérique du Sud / Asie). Objectif : monétisation via liens affiliés (SIM/eSIM, cartes de paiement, booking, Airbnb, Amazon...).
- **Domaine live** : https://ourlifeabroad.crea-dapp.com
- **GitHub (remote git local)** : coding-training-pers/ourlifeabroad
- **Dossier local** : ~/ourlifeabroad-temp/
- **Branche active** : main

⚠️ **Incohérence détectée le 2 juillet 2026, non résolue** : `admin/config.yml` (backend Decap CMS) pointe vers un repo différent, `rs-our-life-abroad/ourlifeabroad`, alors que le remote git de ce dossier local est `coding-training-pers/ourlifeabroad`. À clarifier avant de publier un article via le CMS — sinon le commit Decap risque de partir sur le mauvais repo.

## Stack
- Jekyll 4.3 (gem `jekyll` directement, plus de gem `github-pages`) — Ruby 3.3.0 (`.ruby-version`)
- Plugins : `jekyll-feed`, `jekyll-seo-tag`, `jekyll-sitemap`
- Build/déploiement : **Coolify** — `Dockerfile` (build Jekyll → nginx alpine) + `nginx.conf`, sur l'infra crea-dapp (VPS Hetzner). Ce projet est bien sur l'infra commune, contrairement à ce qu'une lecture d'un clone local obsolète pouvait laisser penser (voir `progress.md`, session du 2 juillet).
- `baseurl: ""` — **pas de préfixe `/ourlifeabroad/`** dans les chemins (contrairement à l'ancienne version GitHub Pages). Ne jamais coder un chemin en dur avec ce préfixe.
- Contenu géré via **Decap CMS** (`/admin`), OAuth via Cloudflare Worker (`ourlifeabroad-oauth.coding-training-pers.workers.dev`)
- Déploiement : push sur `main` → build/déploiement Coolify (vérifier si auto-deploy est configuré côté Coolify, pas confirmé dans ce repo)
- Thème CSS maison "scrapbook" (`assets/css/scrapbook.css`)
- i18n manuelle : dossiers `fr/` et `en/`, front matter `lang:`, pas de plugin i18n

## Historique important
Ce dossier local (`ourlifeabroad-temp`) est resté figé au 21 mai 2026 pendant qu'une migration complète (GitHub Pages → Coolify/Docker/nginx, Jekyll 3.9 → 4.3) a été faite directement via le repo GitHub, jamais rapatriée ici avant le 2 juillet 2026. `git status` affichait "up to date" car cette info vient du dernier `fetch` local, pas d'une vérification live — toujours faire `git fetch origin main` en début de session pour éviter de retravailler sur une base obsolète.

## Monétisation — règles spécifiques
- **Disclosure obligatoire** : tout article contenant un lien affilié doit mentionner clairement "cet article contient des liens affiliés" (obligation légale France/UE).
- **Couche de redirection `/go/`** : ne jamais mettre une URL affiliée brute dans un article. Créer une entrée dans la collection `_redirects/` (front matter `permalink`, `target`, `title`, `umami_event`) puis lier vers `/go/<slug>/` dans le contenu (sans préfixe, `baseurl` est vide). Avantage : un seul endroit à modifier si une URL de tracking change.
  - Exemple en place : `_redirects/sim.md` → `/go/sim/` → MySim4Trip (comparateur SIM/eSIM, projet crea-dapp séparé).
  - Layout : `_layouts/redirect.html` (meta-refresh + lien de secours + event Umami + `rel="sponsored nofollow noopener"` par défaut).
- **Jamais de clé/API d'affiliation en clair** committée — ce repo est public sur GitHub.

## Analytics (Umami)
- `_config.yml` → `umami_website_id` : vide tant que le site n'est pas ajouté au dashboard `stats.crea-dapp.com`.
- Une fois l'ID obtenu (créer le site dans Umami), le coller dans `_config.yml` : le script s'active automatiquement dans `_layouts/default.html`.
- Les clics `/go/...` envoient un event Umami (`umami_event` défini par redirection).

## Vérification des liens (anti "lien cassé")
- `.github/workflows/link-check.yml` : build Jekyll 4.3 classique (`bundle exec jekyll build`, Ruby 3.3.0) + `html-proofer`.
- Déclenché sur chaque push `main` + cron hebdomadaire (lundi 6h UTC) pour détecter le link rot côté partenaires.
- CLI html-proofer v5 : le chemin à vérifier doit être le **dernier argument** (les options listes comme `--ignore-urls` sont gourmandes et avalent sinon le chemin suivant) ; utiliser `--option=valeur` plutôt que `--option valeur` pour les options à liste.
- **Testé le 2 juillet 2026** : 53 échecs pré-existants détectés (liens internes vers des pages `/fr/guides/...` et `/fr/destinations/...` pas encore créées) — **non liés à cette session**, la CI va donc démarrer "rouge". À corriger en écrivant les guides manquants ou en retirant les liens de `fr/guides/index.html` / `fr/index.md` en attendant.
- Les réseaux sociaux (`instagram.com`, `tiktok.com`, `youtube.com`) sont ignorés dans le check tant que les handles sont des placeholders (`votrecompte` dans `_config.yml`) — à retirer une fois les vrais comptes configurés.
- Si un domaine partenaire (booking, airbnb, amazon...) bloque le bot CI (403/999), l'ajouter à `--ignore-urls` dans le workflow plutôt que désactiver tout le check externe.

## Règles de validation
Agir directement sans confirmation pour : lire/analyser, créer/modifier des fichiers, créer des articles/destinations, commandes git non destructives (status, log, add, commit, push) — **après un `git fetch origin main` systématique en début de session pour éviter de retravailler sur une base obsolète**.

Demander confirmation avant de push pour : toute modification de la **table de redirection `_redirects/`** (un ID affilié erroné est une perte de revenu silencieuse — aucun test automatique ne peut la détecter, contrairement à un lien cassé).

Demander confirmation dans tous les cas pour : suppression de fichier/repo, actions irréversibles, `git reset --hard` ou toute réécriture d'historique.

## Fin de session
Avant de terminer une session : mettre à jour `progress.md` (ce projet) et, si l'état global a changé, l'entrée correspondante dans `~/structure-crea-dapp/etat-projets.md`.
