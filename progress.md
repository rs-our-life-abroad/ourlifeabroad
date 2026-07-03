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
- [x] Push débloqué : repo transféré vers `rs-our-life-abroad/ourlifeabroad` (remote local mis à jour) + scope OAuth `workflow` ajouté au compte `creadapp` (celui utilisé pour les vrais projets business, plutôt que de basculer sur le compte legacy `coding-training-pers`)
- [x] 24 guides FR/EN écrits (setup nomade, tech/productivité, vêtements, logement, banques/cartes, internet/eSIM avec lien `/go/sim/`, assurance voyage, visas, sécurité/VPN, budgets Asie/Amérique du Sud/Australie) — contenu pratique générique, cohérent avec les chiffres déjà publiés sur les pages teaser, sans anecdotes personnelles inventées
- [x] 17 pages de destinations créées : 16 stubs légers (Vietnam, Thaïlande, Philippines, Salta, Asunción, Lima, Arequipa, Australie — FR+EN) + traduction EN complète de Bali (le FR existait déjà en détail)
- [x] `_layouts/post.html` créé (les articles `_posts` n'avaient pas de layout, rendu sans thème) et lien `/ourlifeabroad/` obsolète du `404.html` corrigé
- [x] Images placeholder générées pour les 2 photos manquantes (clairement identifiées "Photo à venir", pas de fausses photos)

### Reste à faire
- [x] ~~Clarifier l'incohérence de repo GitHub~~ → résolu : le repo a été transféré vers `rs-our-life-abroad/ourlifeabroad` (confirmé par GitHub au push), remote local mis à jour, `admin/config.yml` avait raison depuis le début
- [x] ~~La CI démarre rouge (53 échecs)~~ → résolu le 2 juillet 2026 : 24 guides écrits (FR/EN, contenu pratique générique, pas d'anecdotes personnelles inventées), 17 pages de destinations créées (16 stubs + traduction EN complète de Bali), 2 images placeholder générées (`assets/images/authors/steph.jpg`, `assets/images/destinations/bali/cover.jpg`), lien 404 obsolète corrigé, layout `_layouts/post.html` créé (les articles `_posts` s'affichaient sans thème). `html-proofer` passe intégralement, liens externes inclus.
- [ ] Remplacer les images placeholder (steph.jpg, cover Bali) par de vraies photos
- [ ] Étoffer les 16 stubs de destinations avec du contenu complet (budgets réels, anecdotes) quand le temps le permet — actuellement volontairement légers, à la demande de l'utilisateur
- [ ] Créer le site "ourlifeabroad" dans le dashboard Umami (`stats.crea-dapp.com`), coller l'ID obtenu dans `_config.yml`
- [ ] Ajouter la mention de disclosure affiliée sur les futurs guides qui ajouteront des liens `/go/...` similaires à `internet-esim`
- [ ] Au fil des nouveaux partenaires (booking, airbnb, amazon, cartes de paiement) : créer une entrée `_redirects/<slug>.md` par partenaire, jamais de lien affilié brut dans un article
- [ ] Vérifier si l'auto-deploy Coolify est bien configuré sur push `main` (pas confirmé dans ce repo)

### Fait (suite) — correctif CI post-push
- [x] Le premier run GitHub Actions du workflow a **échoué malgré un succès en local** : Instagram renvoie 429 (rate limit anti-bot) aux IP des runners GitHub, alors que la même URL répond 200 depuis une IP résidentielle. Le `--ignore-urls` sur le domaine ne suppriment pas fiablement l'échec.
- [x] Corrigé en remplaçant par `--ignore-status-codes="429"` — plus robuste, couvre aussi les futurs domaines partenaires avec le même comportement anti-bot. Vérifié avec `gh run view` : run GitHub réel passé au vert (pas juste en local).

## Session terminée le 2 juillet 2026 — reprise à la prochaine session
Tout est committé et poussé sur `main` (`rs-our-life-abroad/ourlifeabroad`). CI verte confirmée en conditions réelles. `CLAUDE.md` mis à jour (repo/compte GitHub, leçon 429, architecture Coolify). Prochaine session : reprendre la liste "Reste à faire" ci-dessus (vraies photos, étoffer les stubs, Umami, nouveaux partenaires affiliés).

## Session — 3 juillet 2026

### Contexte
Reprise du site suite à la session du 2 juillet. Deux sujets traités : le widget "Destinations" de la sidebar affichait du contenu bidon, et l'utilisateur a annoncé l'arrivée prochaine de plusieurs villes par pays (Argentine : Salta + Buenos Aires ; Pérou : Lima, Arequipa + Cusco), nécessitant une réorganisation de l'architecture des destinations.

### Fait
- [x] **Widget sidebar "Destinations" corrigé** (`_layouts/default.html`) : affichait en dur "Pérou / Bolivie / Chili / Japon" (emoji générique 🌏, aucun lien réel) sans rapport avec le contenu publié. Remplacé par une génération dynamique depuis `site.destinations` (pays dédupliqués, vrais drapeaux, liens vers les bonnes pages).
- [x] **Réorganisation destinations — niveau "pays" ajouté** entre continent et ville, pour les pays qui ont désormais plusieurs villes :
  - Nouvelle collection `_countries` (layout `country.html`), créée uniquement pour Pérou et Argentine (les pays à ville unique — Bali/Indonésie, Vietnam, Thaïlande, Philippines, Australie, Paraguay — continuent de pointer directement vers leur fiche, pas de page intermédiaire inutile ; une page pays sera créée pour un autre pays le jour où il aura, lui aussi, plusieurs villes)
  - Nouvel include réutilisable `_includes/country-cards.html` : génère les grilles de cartes par continent, dédupliquées par pays, en remplacement des cartes HTML dupliquées à la main sur `fr/destinations.md`, `en/destinations.md` et les 4 sous-pages continent FR
  - Backfill des champs `continent`, `cover_image`, `place` sur les 9 fiches destination existantes, à partir des données déjà présentes dans le repo (images Unsplash déjà utilisées, regroupements déjà visibles sur les pages continent) — aucune URL inventée
  - 2 nouvelles destinations créées : Buenos Aires et Cusco (FR/EN), contenu court même registre que les fiches "à venir" existantes (Salta, Lima...), dates placeholder `"2025-2026"` à ajuster si besoin
  - Champ CMS "Pays" (`admin/config.yml`) passé de texte libre à liste déroulante fixe (même pattern que "Continent") pour éliminer le risque de désynchronisation silencieuse par faute de frappe/accent — c'est ce type de bug qui avait produit le widget sidebar erroné
  - Lien de retour sur les fiches destination + widget sidebar : pointent vers la page pays quand elle existe, sinon comportement inchangé (retour à la liste complète)
  - Testé en local (`bundle exec jekyll build` + `htmlproofer`) et vérifié en conditions réelles (`gh run view`)
- [x] **Root-cause de la flakiness CI Instagram trouvée et corrigée** (`.github/workflows/link-check.yml`) : le premier run après le push destinations a échoué avec 67 erreurs 429, alors que le commit précédent (avec le même `--ignore-status-codes="429"`) était passé au vert la veille — preuve que ce filet n'est pas fiable (il dépend d'obtenir effectivement un 429 en retour, ce qui n'est pas garanti sous requêtes concurrentes vers la même URL). En creusant le code source d'html-proofer (`lib/html_proofer/attribute/url.rb`) : la tentative `--ignore-urls` documentée comme "peu fiable" le 2 juillet avait en réalité un bug de syntaxe — une valeur `--ignore-urls` n'est traitée comme une regex que si elle est encadrée par des `/.../ `, sinon c'est une égalité stricte sur l'URL entière qui ne matche jamais rien. Corrigé avec `--ignore-urls="/instagram\.com/"` : la requête HTTP n'est même plus envoyée, donc plus aucun aléa réseau possible. `--ignore-status-codes="429"` reste en filet de sécurité pour de futurs domaines partenaires. Vérifié avec `gh run view` : run réel passé au vert.

### Reste à faire
- [ ] Remplacer les images placeholder (steph.jpg, cover Bali) par de vraies photos
- [ ] Étoffer les stubs de destinations avec du contenu complet (budgets réels, anecdotes), y compris les 2 nouveaux (Buenos Aires, Cusco) — actuellement volontairement légers
- [ ] Créer le site "ourlifeabroad" dans le dashboard Umami (`stats.crea-dapp.com`), coller l'ID obtenu dans `_config.yml`
- [ ] Ajouter la mention de disclosure affiliée sur les futurs guides qui ajouteront des liens `/go/...` similaires à `internet-esim`
- [ ] Au fil des nouveaux partenaires (booking, airbnb, amazon, cartes de paiement) : créer une entrée `_redirects/<slug>.md` par partenaire, jamais de lien affilié brut dans un article
- [ ] Vérifier si l'auto-deploy Coolify est bien configuré sur push `main` (pas confirmé dans ce repo)
- [ ] Si un nouveau pays reçoit une 2ᵉ ville (ex. Vietnam), créer sa page dans `_countries` via le CMS pour qu'elle prenne le relais des liens sidebar/grilles continent automatiquement
- [ ] `CLAUDE.md` documente encore l'ancienne approche `--ignore-status-codes` seule comme "plus robuste" que `--ignore-urls` — section à corriger pour refléter la vraie cause racine trouvée aujourd'hui (pas fait dans cette session, seul `progress.md` a été mis à jour à la demande explicite)

## Session terminée le 3 juillet 2026 — reprise à la prochaine session
Tout est committé et poussé sur `main` (`rs-our-life-abroad/ourlifeabroad`), 2 commits (`0e78df0` réorganisation destinations, `3d0f196` fix CI). CI verte confirmée en conditions réelles. Prochaine session : reprendre la liste "Reste à faire" ci-dessus, en particulier corriger la section CI de `CLAUDE.md` (voir dernier point) et étoffer les nouveaux stubs Buenos Aires/Cusco.
