# progress.md — Our Life Abroad

## Historique avant mise en place du suivi (résumé, cf. `git log` pour le détail)
- Decap CMS installé (`/admin`), backend GitHub, OAuth via Cloudflare Worker (après plusieurs itérations : Render → Cloudflare)
- Thème "scrapbook" créé : styles articles/destinations (effet Polaroid), grille accueil/destinations, nettoyage emojis avion
- **Migration Coolify (26-27 mai 2026)** : abandon de GitHub Pages, passage à Jekyll 4.3 direct (Ruby 3.3), ajout `Dockerfile` + `nginx.conf`, nouveau domaine `ourlifeabroad.crea-dapp.com`, `baseurl` vidé, tous les chemins `/ourlifeabroad/` en dur corrigés
- Ajout pages continents + destinations EN + retouches home FR

## Session — 2 juillet 2026

### Contexte
Discussion sur l'adaptation du prompt de démarrage partagé (crea-dapp) à ce projet, en vue de la monétisation du site (liens affiliés : SIM/eSIM, cartes de paiement, booking, Airbnb, Amazon...).

### Incident de session — dossier local obsolète
Ce dossier (`ourlifeabroad-temp`) n'avait pas été synchronisé depuis le **21 mai 2026** (avant la migration Coolify). `git status` affichait "up to date with origin/main" en début de session, ce qui a induit en erreur : cette info reflète le dernier `fetch` local, pas une vérification live du remote. Une première itération de tout le travail ci-dessous a donc été faite par erreur sur la base de l'ancienne architecture GitHub Pages (`baseurl: /ourlifeabroad`, gem `github-pages`).

**Résolution** :
1. Sauvegarde de ce premier essai sur la branche `backup-session-affiliation` (commit `e7bb8cb`) — non poussée, conservée au cas où.
2. `git reset --hard origin/main` pour repartir de l'état réel (post-migration Coolify).
3. Refonte du travail ci-dessous, adapté à la vraie architecture (`baseurl: ""`, Jekyll 4.3, Coolify).

**Leçon retenue** : toujours faire `git fetch origin main` explicitement en début de session avant de supposer que le dossier local est à jour (ajouté à `CLAUDE.md`).

### Décisions prises
- Ce projet est **bien sur l'infra crea-dapp** (Coolify), contrairement à ce qui avait été supposé avant de découvrir la migration.
- **Umami** : réutilisation de l'instance partagée `stats.crea-dapp.com` (nouveau site dans le même dashboard), pas d'instance dédiée.
- **Liens affiliés** : couche de redirection interne `/go/<slug>/` plutôt que des URLs brutes dans les articles, pour centraliser les changements d'URL de tracking.
- **Push** : auto-push conservé pour le contenu/code courant ; confirmation demandée uniquement pour les modifications de la table de redirection `_redirects/` (erreur d'ID affilié = perte de revenu silencieuse, non détectable par un test automatique).
- **Vérification des liens** : `html-proofer` en CI (GitHub Actions), déclenché sur push + cron hebdomadaire.
- **Fichiers de suivi** : `CLAUDE.md` + `progress.md` locaux (détail session par session) + entrée résumée dans `~/structure-crea-dapp/etat-projets.md` commun (comme les 9 autres projets).

### Fait
- [x] `CLAUDE.md` créé (contexte, stack Coolify, règles monétisation/push/redirection, incident dossier obsolète)
- [x] `_config.yml` : ajout collection `redirects` (output: true), défaut `layout: redirect` + `rel: sponsored nofollow noopener`, clé `umami_website_id` (vide)
- [x] `_layouts/redirect.html` créé (meta-refresh + lien de secours + event Umami)
- [x] `_redirects/sim.md` créé : `/go/sim/` → MySim4Trip (`https://mysim4trip.crea-dapp.com`, vérifié en ligne : HTTP 200)
- [x] Script Umami ajouté dans `_layouts/default.html` (conditionnel à `site.umami_website_id`)
- [x] `.github/workflows/link-check.yml` créé et **testé en local** (`bundle install` + `bundle exec jekyll build` + `htmlproofer` fonctionnent avec Jekyll 4.3/Ruby 3.3 — contrairement à l'ancienne base GitHub Pages qui plantait avec Ruby ≥ 3.2)
- [x] Découvert en testant : la syntaxe CLI html-proofer v5 exige le chemin en dernier argument et `--option=valeur` pour les options listes (sinon le chemin est avalé par `--ignore-urls`)
- [x] Vérifié que `/go/sim/` ne remonte aucune erreur dans le check de liens

### Reste à faire
- [ ] **Clarifier l'incohérence de repo GitHub** : `admin/config.yml` (Decap) pointe vers `rs-our-life-abroad/ourlifeabroad`, le remote git local est `coding-training-pers/ourlifeabroad` — lequel est le bon ?
- [ ] La CI va démarrer **rouge** : 53 échecs pré-existants détectés en local (liens vers guides/destinations pas encore créés dans `fr/guides/index.html`, `fr/index.md`) — non liés à cette session, à traiter en écrivant le contenu ou en retirant les liens
- [ ] Créer le site "ourlifeabroad" dans le dashboard Umami (`stats.crea-dapp.com`), coller l'ID obtenu dans `_config.yml`
- [ ] Rédiger le premier article avec lien `/go/sim/` + mention de disclosure affiliée
- [ ] Retirer `instagram.com/tiktok.com/youtube.com` du `--ignore-urls` de la CI une fois les vrais comptes réseaux sociaux configurés (actuellement `votrecompte` dans `_config.yml`)
- [ ] Au fil des nouveaux partenaires (booking, airbnb, amazon, cartes de paiement) : créer une entrée `_redirects/<slug>.md` par partenaire, jamais de lien affilié brut dans un article
- [ ] Vérifier si l'auto-deploy Coolify est bien configuré sur push `main` (pas confirmé dans ce repo)
