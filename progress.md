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
- [x] ~~Vérifier si l'auto-deploy Coolify est bien configuré sur push `main`~~ → **confirmé le 26/08** : il fonctionne (conteneur déployé 4 s après le push, image taguée avec le SHA du dernier commit)

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
- [x] ~~Vérifier si l'auto-deploy Coolify est bien configuré sur push `main`~~ → **confirmé le 26/08** : il fonctionne (conteneur déployé 4 s après le push, image taguée avec le SHA du dernier commit)
- [ ] Si un nouveau pays reçoit une 2ᵉ ville (ex. Vietnam), créer sa page dans `_countries` via le CMS pour qu'elle prenne le relais des liens sidebar/grilles continent automatiquement
- [ ] `CLAUDE.md` documente encore l'ancienne approche `--ignore-status-codes` seule comme "plus robuste" que `--ignore-urls` — section à corriger pour refléter la vraie cause racine trouvée aujourd'hui (pas fait dans cette session, seul `progress.md` a été mis à jour à la demande explicite)
- [ ] Nouveaux sujets de guides retenus le 18 juillet 2026 (pas encore rédigés) : vols pas chers/comparateur billets d'avion, santé & vaccins en voyage, argent liquide & change de devises
- [ ] Guide matériel audio/vidéo (setup de tournage/prise de son) — l'utilisateur le rédigera lui-même, pas délégué

## Session terminée le 3 juillet 2026 — reprise à la prochaine session
Tout est committé et poussé sur `main` (`rs-our-life-abroad/ourlifeabroad`), 2 commits (`0e78df0` réorganisation destinations, `3d0f196` fix CI). CI verte confirmée en conditions réelles. Prochaine session : reprendre la liste "Reste à faire" ci-dessus, en particulier corriger la section CI de `CLAUDE.md` (voir dernier point) et étoffer les nouveaux stubs Buenos Aires/Cusco.

## Session — 18 juillet 2026

### Contexte
Session de méthodo/préparation d'écriture de contenu, pas de code touché dans le repo. Deux sujets : (1) définir une structure standard pour les guides et pour les articles de destination, (2) proposer de nouveaux sujets de guides.

### Fait
- [x] Structure de guide définie à partir des fichiers existants (`internet-esim`, `_posts/notre-setup-nomade`) : front matter, plan de section, règles transverses (bilingue, disclosure, redirection `/go/`)
- [x] Squelette de guide (FR + EN) rédigé et sauvegardé en scratchpad (pas dans le repo — évite qu'une page vide soit construite par Jekyll tant qu'il n'est pas rempli et déplacé dans `fr/guides/`/`en/guides/`)
- [x] 5 sujets de guides proposés ; 3 retenus par l'utilisateur : vols pas chers/comparateur billets d'avion, santé & vaccins en voyage, argent liquide & change de devises. Un 4e (matériel photo/vidéo) sera écrit directement par l'utilisateur, pas délégué.
- [x] Recherche externe sur la structure des articles de destination des gros blogs voyage : Nomadic Matt (guide SEO exhaustif : top attractions, budgets par niveau, sécurité, saisons, ressources de réservation) et The Broke Backpacker (ton perso, itinéraires par durée, villes une par une)
- [x] Squelette d'article destination (FR + EN) rédigé en scratchpad, calé sur le ton déjà éprouvé de la fiche Bali existante (`_destinations/bali-fr.md` / `bali-en.md`) + 2 sections ajoutées inspirées de la recherche externe : "Sécurité & arnaques à éviter" et "Comment y aller & se déplacer", absentes de la fiche Bali actuelle
- [x] Repéré au passage (non corrigé, à traiter plus tard) : la fiche Bali en ligne contient des liens affiliés placeholder en `href="#"` (Klook, SafetyWing, Airbnb, Booking) — à faire passer par `_redirects/` → `/go/<slug>/` quand ils seront activés, jamais l'URL brute

### Reste à faire (ajouté à la liste ci-dessus)
- [ ] Rédiger les 3 guides retenus (vols pas chers, santé & vaccins, argent liquide/change) à partir du squelette
- [ ] Remplir le squelette de destination pour une vraie ville et le publier
- [ ] Corriger les liens placeholder `href="#"` de la fiche Bali (Klook/SafetyWing/Airbnb/Booking) via `_redirects/` le jour où ces partenariats sont activés

## Session terminée le 18 juillet 2026 — reprise à la prochaine session
Aucun commit/push cette session (uniquement `progress.md` modifié dans le repo ; les 2 squelettes de guide + les 2 squelettes de destination sont en scratchpad, pas dans le repo). Prochaine session : rédiger les 3 guides retenus et/ou remplir un squelette de destination pour une vraie ville, à partir des templates créés aujourd'hui.

## Session 2026-07-06 (soir) — encart eSIM automatique sur les pages destination

- `_includes/esim-box.html` : encart bilingue (FR/EN via `page.lang`, nom de ville interpolé via `page.place`) affiché automatiquement sur toutes les pages destination, entre le contenu et le footer. Style scrapbook (Patrick Hand, ombre dure, légère rotation).
- CTA principal → `/go/sim/` (la redirection interne monétisée, événement Umami `click-go-sim`) ; lien secondaire → le guide `internet-esim` de la langue courante. Jamais d'URL partenaire en dur — conforme à la convention `_redirects/`.
- Branché dans `_layouts/destination.html` (une ligne). Vérifié en build local : Arequipa FR ("Internet à Arequipa ?") et EN ("Staying connected in Arequipa?"), liens corrects dans les deux langues.
- Contexte : Phase 1 du plan portefeuille (`structure-crea-dapp/plan-2026-07.md`) — renforcer le seul flux d'acquisition actif de MySim4Trip. Chaque destination (17+) fait maintenant du maillage vers la redirection au lieu du seul guide eSIM.

## Session — 11 août 2026 — icône animée « tiny planet »

### Contexte
Demande : afficher une courte vidéo tiny planet (Insta360) en boucle dans un coin haut de page, comme une icône animée. Choix validés par l'utilisateur : **coin haut droit, fixe (reste visible au scroll), sur toutes les pages**, et **cliquable → accueil de la langue courante**.

### Fait
- [x] `_includes/tiny-planet.html` : markup `<video autoplay muted loop playsinline>` enveloppé dans un lien vers `/fr/` ou `/en/` selon `page.lang`, avec `aria-label` traduit et `aria-hidden` sur la vidéo. **Rendu conditionnel à l'existence réelle du fichier** (`site.static_files | where: "path", "/assets/video/tiny-planet.mp4"`) : tant que la vidéo n'est pas déposée, l'include ne produit rien — pas de lecteur cassé, pas d'erreur de build, CI verte.
- [x] Petit script inline : respecte `prefers-reduced-motion` (fige l'icône sur sa première image au lieu de la laisser tourner).
- [x] CSS ajouté en fin de `assets/css/scrapbook.css` : `position: fixed` haut/droite, rond, bordure `--paper-white` + ombre dure et légère rotation (style scrapbook), agrandissement au survol, `outline` au focus clavier. Tailles dégressives (110px → 78px → 64px) et masquage sous 420px de hauteur (mobile en paysage).
- [x] Branché en une ligne dans `_layouts/default.html`. Vérifié que `_layouts/index.html` est un **vestige inutilisé** (aucune page ne le référence ; les vraies accueils `fr/index.md`/`en/index.md` sont en `layout: default`) — le branchement unique couvre donc bien tout le site. `_layouts/redirect.html` est volontairement exclu (page de rebond meta-refresh).
- [x] `tools/make-tiny-planet.sh` : encode la vidéo source pour le web (recadrage carré centré, 480x480, audio coupé — obligatoire pour l'autoplay navigateur, durée limitée). Variables `START` / `DURATION` / `SIZE` ajustables.
- [x] **WebM abandonné après mesure** : le VP9 sortait à 489 Ko contre 245 Ko pour le H.264 sur ce type de plan, alors que l'include le servait en priorité — soit exactement l'inverse du but recherché. Le H.264 étant lu par tous les navigateurs, le WebM a été retiré du script et de l'include plutôt que tuné à l'aveugle.
- [x] Testé de bout en bout avec une vidéo témoin (`SALTA TEST.mov`) : rendu vérifié dans Chrome (icône ronde en place, en lecture, fixe au scroll, sans recouvrir la sidebar), bilinguisme du lien confirmé (`/fr/` vs `/en/`), et `htmlproofer` passé avec **les options exactes de la CI** dans les deux états (avec et sans vidéo). Vidéo témoin supprimée ensuite — elle n'est pas committée.

### Durée de vidéo — mesures (15 août 2026)
Encodage du même plan à différentes durées, pour cadrer le choix :

| Durée | 480×480 | 360×360 |
|---|---|---|
| 4 s | 136 Ko | 93 Ko |
| 8 s | 372 Ko | 241 Ko |
| 12 s | 833 Ko | 530 Ko |
| 20 s | 1 308 Ko | 825 Ko |
| 30 s | 1 809 Ko | 1 138 Ko |

≈ 45 Ko/s en 480px, 28 Ko/s en 360px. Recommandation : **8 s, 12 s au maximum**. Repère : la page d'accueil fait 10 Ko et tout le CSS 21 Ko — la vidéo domine le poids de la page. Mesures faites sur un plan à main levée en décor chargé (pire cas de compression) : un tiny planet en rotation lente compressera mieux.
**À noter** : l'icône s'affiche à 110 px, soit 330 px sur un écran 3x — **360×360 suffit largement, 480 est du gaspillage**. Défaut du script laissé à 480 (décision non tranchée par l'utilisateur).

### Cache HTTP (`nginx.conf`) — fait le 15 août 2026
Le `nginx.conf` ne définissait **aucun en-tête de cache** : chaque page rechargeait les assets plus souvent que nécessaire, ce qui devenait coûteux avec une vidéo servie sur toutes les pages.

- **Contrainte structurante** : aucun fichier de ce site n'a de hash dans son nom (`scrapbook.css`, `tiny-planet.mp4` gardent le même nom d'une version à l'autre). Un `immutable` longue durée figerait donc l'ancienne version chez les visiteurs déjà venus, sans moyen de les rattraper. Les durées sont donc calées sur « à quel point c'est grave si le visiteur voit la version d'avant », pas sur le poids du fichier.
- **Médias** (mp4/webm/jpg/png/webp/svg/ico/woff) : `Cache-Control: public, max-age=2592000` (30 j). On ne remplace pas une photo en place, on en publie une nouvelle.
- **CSS/JS et HTML** : `Cache-Control: no-cache` → le navigateur garde le fichier mais revalide ; nginx répond **304 avec 0 octet de corps** tant que rien n'a changé. Une modif de style est donc visible immédiatement, sans jamais retélécharger le fichier entier.
- **gzip activé** sur les types compressibles uniquement (pas sur mp4/jpg, déjà compressés).
- **Piège rencontré et corrigé** : `expires 30d;` émet son propre `Cache-Control`, qui s'ajoutait à celui du `add_header` → **deux en-têtes `Cache-Control` concurrents** sur la même réponse. La directive `expires` a été retirée, un seul en-tête explicite conservé.
- **Vérifié pour de vrai**, pas sur parole : nginx installé en local (`brew install nginx`, désinstallable avec `brew uninstall nginx`), config du repo rejouée telle quelle sur un port de test — Docker n'étant pas disponible sur cette machine. Résultats mesurés : `nginx -t` OK (une erreur de syntaxe ici ferait planter le conteneur au démarrage et tomberait le site), un seul `Cache-Control` par réponse, revalidation 304 à 0 octet sur HTML et CSS, gzip 10,9 Ko → 3,6 Ko sur l'accueil et 21,2 Ko → 5,7 Ko sur le CSS, mp4 non compressé comme voulu.

### Outillage local ajouté sur le Mac
`brew install nginx` — installé pour rejouer `nginx.conf` en local, Docker n'étant pas disponible sur cette machine. Réutilisable pour tout projet crea-dapp servi par nginx (`nginx -t` avant un push évite de faire tomber un site sur une faute de syntaxe). Désinstallation : `brew uninstall nginx`. Aucun service en arrière-plan lancé (`brew services` non utilisé) — nginx n'est démarré qu'à la demande sur un port de test.

## Session — 17 août 2026 : vidéo tiny planet déposée, les deux points bloquants sont levés

Source fournie : `~/Desktop/tiny world cut.mp4` — 1920×1080 HEVC, 6,05 s, **18,7 Mo** (24,8 Mb/s). Sortie finale : **335 Ko**, soit −98 %.

### Résolution tranchée : 360×360 (le point « 480 vs 360 » est clos)
Le `SIZE` par défaut du script passe de 480 à **360**, et `CRF` de 30 à **33**. Départage par la mesure, pas par le raisonnement : trois variantes (480/CRF 30 = 977 Ko, 360/CRF 33 = 375 Ko, 288/CRF 36 = 148 Ko) ont été rendues **à la taille d'affichage réelle** (220 px, soit l'icône de 110 px en retina) et comparées côte à côte — **indiscernables**. 360/33 est retenu parce qu'il garde de la marge jusqu'à 3× retina.
**Méthode à réutiliser** : comparer à la taille d'affichage, pas en 1:1. En 1:1 les écarts sautent aux yeux et poussent à surdimensionner ; c'est ce qui avait fait retenir 480 au départ.

### Le raccord de boucle — le vrai sujet, qui n'était pas la compression
La note de la session précédente (« choisir un extrait dont la 1re et la dernière image se ressemblent ») ne pouvait pas être suivie : sur ce plan la planète a tourné, fin et début ne se ressemblent pas, et **aucun choix d'extrait ne l'aurait corrigé**. Le saut était visible à chaque cycle. Trois options mesurées, arbitrage laissé à l'utilisateur :

| Option | Poids | Durée | Défaut |
|---|---|---|---|
| Brut (aucun traitement) | 375 Ko | 6,0 s | saut visible à chaque boucle |
| Aller-retour (`reverse`) | 748 Ko | 12,0 s | rotation qui s'inverse ; 2× le poids |
| **Fondu enchaîné** ✅ | **335 Ko** | 5,2 s | image dédoublée 0,8 s par cycle |

**Retenu : le fondu** (choix utilisateur) — le plus léger des trois *et* boucle invisible ; la contrepartie est le dédoublement pendant le fondu.

### Piège trouvé en chemin : le fondu doit être en FIN de timeline
Placé au début (construction naturelle), la **première image** de la vidéo est l'image floue du fondu. Or c'est exactement l'image que voient (a) le poster et (b) les utilisateurs en `prefers-reduced-motion`, pour qui `_includes/tiny-planet.html` met la vidéo **en pause sur sa première image** — ils auraient eu une icône figée en flou, de façon permanente. Le montage a donc été réordonné (`[body]` puis `[mix]`), ce qui laisse la boucle tout aussi invisible mais rend la 1re image nette.
Corollaire appliqué : le **poster est maintenant extrait du MP4 produit**, plus de la source — sinon il ne correspond plus à la première image dès qu'un découpage est appliqué, et le passage poster → lecture saute.

### Autre piège ffmpeg
`-t` placé **après** `-i` est une option de *sortie* : elle tronque le résultat au lieu de limiter la source. Avec un `filter_complex` qui rallonge la timeline (aller-retour), le rendu sortait à 6 s / 144 images au lieu de 12 s / 288. Mettre `-t` **avant** `-i`.

### Fait
- [x] `assets/video/tiny-planet.mp4` (335 Ko) + `tiny-planet.jpg` (26 Ko) déposés → **l'include n'est plus inerte**, le lecteur est rendu (vérifié sur le build, pages `fr` et `en`)
- [x] `tools/make-tiny-planet.sh` mis à jour : défauts 360/CRF 33, nouvelles options `CRF` et `FADE` (`FADE=0` désactive le fondu), poster extrait du MP4, en-tête documentant le pourquoi de chaque valeur. **Les deux branches (`FADE=0.8` et `FADE=0`) ont été exécutées**, et le script **reproduit le fichier livré octet pour octet**.
- [x] `.DS_Store` ajouté au `.gitignore` (il traînait non suivi dans `assets/`)
- [x] Commit `3b305ea` poussé sur `main`. Disque VPS vérifié avant push : **71 %** (seuil 85 %).

### ✅ RÉSOLU — l'auto-deploy fonctionne. Deux diagnostics faux avant d'y arriver (clos le 26/08)

**Conclusion (26/08) : il n'y avait rien à réparer.** Preuve : le conteneur en production tourne l'image `vp6oc0x9gv8btjsigqqe00fj:ad1b4f489d2e…`, soit exactement le dernier commit poussé, et son nom encode `191013` — **4 secondes après** le push de `ad1b4f4` (19:10:09 UTC). Le site sert bien ce commit (vérifié aussi par le contenu de `/progress.md`, servi tel quel car sans front matter).

**Les deux diagnostics faux, à ne pas refaire :**
1. *« Le dépôt n'a aucun webhook »* — `gh api repos/.../hooks` renvoie une liste vide, mais cette application utilise une **GitHub App**, qui ne crée jamais de webhook au niveau du dépôt. Liste vide = état normal, ne prouve rien.
2. *« La case Auto Deploy est décochée »* — elle était cochée. Hypothèse invérifiable par script (le réglage n'est pas exposé par l'API v1), donc avancée sans preuve. Erreur de méthode : conclure depuis ce qu'on ne peut pas mesurer.

**La vraie anomalie, unique et non reproduite** : le push de `3b305ea` (13:59 UTC) n'a pas déclenché de déploiement — vérifié à 14:03, le conteneur datait encore du 15/08. Cause indéterminée (probablement transitoire). Tous les pushs suivants se sont déployés normalement, et rien ne s'est reproduit en 9 jours.

**Leçon de méthode** : la mesure qui a tranché est le **tag de l'image du conteneur**, qui contient le SHA déployé — `docker ps --format '{{.Image}}'`. C'est la seule source fiable pour savoir *ce qui tourne réellement*, bien avant `hooks`, les réglages ou les logs de la file Coolify.

**Reste ouvert sur ce sujet**
- [ ] Juger le **dédoublement du fondu en conditions réelles** : il a été validé sur images fixes, pas sur la vidéo en mouvement dans la page. S'il gêne, réduire à `FADE=0.4` (fondu plus court, donc plus bref mais plus abrupt) ou repasser à l'aller-retour.
- [ ] La source `~/Desktop/tiny world cut.mp4` n'est **pas** dans le repo (18,7 Mo, dépôt public) — la conserver ailleurs si un ré-encodage est envisagé.

### Permissions Claude Code — `.claude/settings.json` ajouté (17 août 2026)
Scan des 28 sessions locales (4 505 appels Bash) pour réduire les demandes de confirmation. Résultat contre-intuitif : **il n'y avait presque rien à gagner**. La majorité du volume (`grep`, `head`, `tail`, `sed`, `ls`, `git status`/`log`/`diff`…) est **déjà auto-autorisée** par Claude Code, sans aucune règle ; le reste est exclu par nature (écriture, interpréteurs, `ssh`). Seuls ~250 appels étaient réellement allowlistables → 12 entrées strictement en lecture (`curl -sI`, `curl -s -o /dev/null`, `ffprobe`, `crontab -l`, outils navigateur MCP de lecture).

**`ssh` reste volontairement en confirmation** (décision utilisateur). C'est la commande la plus fréquente (448 appels) mais :
- une **règle exacte** est sûre et inutile : celle déjà présente dans `settings.local.json` a correspondu **0 fois sur 81 appels** — 60 formes textuellement distinctes pour la même intention ;
- une **règle sur un script** correspondrait à 100 % mais la permission porte sur un *chemin* alors que ce qui s'exécute est un *contenu* modifiable après coup : « éditer le script » (sans demande) + « l'exécuter » (autorisé) = commande root arbitraire sur le VPS sans aucune confirmation.

Détail complet et mesures dans `~/structure-crea-dapp/etat-projets.md`, section « Ne jamais mettre `ssh` dans une allowlist ».

⚠️ **`.claude/` n'était ni suivi ni ignoré alors que ce dépôt est public.** `.claude/settings.local.json` est désormais dans le `.gitignore` (il contient des chemins locaux ; rappel de l'incident EdgeBook où ce fichier est parti sur un déploiement Vercel public). `.claude/settings.json`, lui, est versionné volontairement — il est partagé et ne contient que des motifs en lecture.

## ⏭️ À FAIRE / À DÉCIDER à la reprise

**Vérifications à faire au prochain passage**
- [ ] Vérifier le rendu de l'icône **sur un vrai téléphone** — le redimensionnement de fenêtre n'a pas pris effet pendant le test Chrome, donc les tailles dégressives (110 → 78 → 64 px) et le masquage en paysage sous 420 px de haut n'ont **pas** été vus en conditions réelles. CSS standard, risque faible, mais non vérifié.
- [x] ~~Confirmer en prod que les en-têtes de cache sont bien servis~~ **fait le 17/08 après le déploiement** : `no-cache` sur le CSS et le HTML, `public, max-age=2592000` sur les médias, gzip actif sur le CSS. Conformes à ce qui avait été testé en local le 15/08.

**Non fait volontairement**
- Le WebM a été retiré (mesuré 2× plus lourd que le H.264 ici). Si un jour la vidéo change de nature et que le WebM redevient pertinent, il faudra le remesurer avant de le réintroduire — et corriger l'ordre des `<source>`, c'est ce qui clochait.

## Session terminée le 17 août 2026 — reprise à la prochaine session
Cinq commits poussés sur `main` : `3b305ea` (vidéo tiny planet 360×360 / 335 Ko avec fondu de bouclage, script mis à jour), `cb2cf1f` + `4dbb55f` + `b0c06c9` (ce suivi) et `ff343a4` (allowlist de permissions en lecture seule + `.claude/settings.local.json` ignoré). CI verte. Disque du VPS : **71 %**, charge 0,49.

✅ **L'icône tiny planet est EN LIGNE** — déploiement lancé manuellement par l'utilisateur à 19:00 et vérifié côté service (mp4 et poster en 200 aux bonnes tailles, include rendu, en-têtes de cache et gzip conformes). Les deux points bloquants du 15/08 sont donc entièrement clos, ainsi que la vérification des en-têtes de cache qui traînait depuis cette date.

✅ **Aucun point ouvert côté déploiement.** Vérifié le 26/08 : l'auto-deploy fonctionne — le conteneur en production tourne l'image taguée `ad1b4f4`, soit le dernier commit, démarrée 4 secondes après le push. Les deux diagnostics posés le 17/08 (webhook manquant, puis case Auto Deploy décochée) étaient **faux** ; voir la section dédiée pour le détail et la leçon de méthode.

**Reprise** : plus rien de bloquant. Vérifications de confort seulement (rendu sur un vrai téléphone, dédoublement du fondu en mouvement). Les chantiers de fond restent inchangés (3 guides à rédiger, stubs à étoffer, Umami à créer, vraies photos).
