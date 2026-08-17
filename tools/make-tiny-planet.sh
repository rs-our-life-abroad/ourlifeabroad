#!/usr/bin/env bash
#
# make-tiny-planet.sh — prépare la vidéo "tiny planet" (Insta360) pour le web.
#
# Usage :
#   ./tools/make-tiny-planet.sh "~/Downloads/ma-video-tiny-planet.mov"
#
# Produit dans assets/video/ :
#   tiny-planet.mp4   (H.264, lu par tous les navigateurs)
#   tiny-planet.jpg   (poster affiché le temps que la vidéo charge)
#
# Pas de WebM : sur ce type de plan (480x480, quelques secondes), le VP9 sortait
# deux fois plus lourd que le H.264 pour un gain de compatibilité nul.
#
# Ce que fait le script :
#   - recadre au carré centré (le tiny planet est circulaire, l'icône est ronde)
#   - réduit à 360x360 (l'icône s'affiche à 110px, soit 220px en retina)
#   - coupe l'audio (l'icône est muette — obligatoire pour l'autoplay navigateur)
#   - limite la durée (une icône n'a pas besoin de 2 minutes de vidéo)
#   - raccorde la boucle par un fondu, sauf si FADE=0
#
# Réglages retenus le 17 août 2026, mesurés sur la source réelle (1080p HEVC,
# 18,7 Mo) : SIZE=480/CRF=30 sortait à 977 Ko, alors qu'à la taille d'affichage
# réelle 480/30, 360/33 et 288/36 sont indiscernables. D'où 360/33 (~335 Ko),
# qui garde de la marge jusqu'à 3x retina.
#
# Le fondu existe parce qu'un plan filmé ne boucle jamais tout seul : sans lui,
# la planète saute visiblement à chaque fin de cycle. Il est placé en FIN de
# timeline, pas au début, pour que la PREMIÈRE image reste nette — c'est elle que
# voient le poster et les utilisateurs en "prefers-reduced-motion", pour qui
# _includes/tiny-planet.html met la vidéo en pause sur cette image.
# Contrepartie assumée : l'image se dédouble pendant FADE secondes par cycle.
#
# Prérequis : ffmpeg (déjà installé via Homebrew sur cette machine).

set -euo pipefail

SRC="${1:-}"
DURATION="${DURATION:-8}"   # secondes conservées, depuis START
START="${START:-0}"         # début de l'extrait dans la source
SIZE="${SIZE:-360}"         # côté du carré de sortie, en pixels
CRF="${CRF:-33}"            # qualité H.264 : plus haut = plus léger
FADE="${FADE:-0.8}"         # durée du fondu de bouclage ; FADE=0 pour le désactiver

if [[ -z "$SRC" ]]; then
  echo "Usage : $0 <fichier-video-source>" >&2
  echo "Options (variables d'environnement) :" >&2
  echo "  START=0 DURATION=8 SIZE=360 CRF=33 FADE=0.8" >&2
  exit 1
fi

# Autorise le ~ dans le chemin passé entre guillemets
SRC="${SRC/#\~/$HOME}"

if [[ ! -f "$SRC" ]]; then
  echo "Fichier introuvable : $SRC" >&2
  exit 1
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg est requis (brew install ffmpeg)." >&2
  exit 1
fi

# Se place à la racine du repo, quel que soit le dossier d'appel
cd "$(dirname "$0")/.."
OUT_DIR="assets/video"
mkdir -p "$OUT_DIR"

# Carré centré sur le plus petit côté, puis mise à l'échelle.
FILTER="crop='min(iw,ih)':'min(iw,ih)',scale=${SIZE}:${SIZE},fps=24"

echo "Source     : $SRC"
echo "Extrait    : ${DURATION}s à partir de ${START}s"
echo "Sortie     : ${OUT_DIR}/tiny-planet.{mp4,jpg} (${SIZE}x${SIZE}, CRF ${CRF})"
if [[ "$FADE" != "0" ]]; then
  echo "Bouclage   : fondu de ${FADE}s en fin de timeline"
else
  echo "Bouclage   : aucun (raccord brut, saut visible en fin de boucle)"
fi
echo

echo "→ MP4 (H.264)…"
if [[ "$FADE" == "0" ]]; then
  ffmpeg -v error -stats -y \
    -ss "$START" -t "$DURATION" -i "$SRC" \
    -vf "$FILTER" \
    -an \
    -c:v libx264 -profile:v main -pix_fmt yuv420p \
    -crf "$CRF" -preset slow -movflags +faststart \
    "${OUT_DIR}/tiny-planet.mp4"
else
  # Découpage du fondu de bouclage. La sortie vaut DURATION-FADE secondes :
  #   [body] = FADE .. DURATION-FADE      (net, commence la vidéo)
  #   [mix]  = fondu de la fin (DURATION-FADE .. DURATION) vers le contenu de
  #            FADE .. 2*FADE, donc vers la 1re image de [body] -> boucle bouclée
  BODY_END=$(awk -v d="$DURATION" -v f="$FADE" 'BEGIN{printf "%.3f", d-f}')
  HEAD_END=$(awk -v f="$FADE" 'BEGIN{printf "%.3f", 2*f}')

  ffmpeg -v error -stats -y \
    -ss "$START" -t "$DURATION" -i "$SRC" \
    -filter_complex "[0:v]${FILTER},setpts=PTS-STARTPTS[v];\
[v]split=3[p1][p2][p3];\
[p1]trim=${FADE}:${BODY_END},setpts=PTS-STARTPTS[body];\
[p2]trim=${BODY_END}:${DURATION},setpts=PTS-STARTPTS[tail];\
[p3]trim=${FADE}:${HEAD_END},setpts=PTS-STARTPTS[head];\
[tail][head]blend=all_expr='A*(1-(T/${FADE}))+B*(T/${FADE})'[mix];\
[body][mix]concat=n=2:v=1" \
    -an \
    -c:v libx264 -profile:v main -pix_fmt yuv420p \
    -crf "$CRF" -preset slow -movflags +faststart \
    "${OUT_DIR}/tiny-planet.mp4"
fi

# Poster = 1re image du MP4 produit (et non de la source) : le passage du poster
# à la lecture est ainsi invisible, quel que soit le découpage appliqué au-dessus.
echo "→ Poster (JPEG)…"
ffmpeg -v error -y \
  -i "${OUT_DIR}/tiny-planet.mp4" -frames:v 1 \
  -q:v 4 \
  "${OUT_DIR}/tiny-planet.jpg"

echo
echo "Terminé :"
ls -lh "${OUT_DIR}"/tiny-planet.* | awk '{print "  " $9 "  " $5}'
echo
echo "Ce repo est public : garder ces fichiers légers (viser < 1,5 Mo au total)."
echo "Trop lourd ? relancer avec CRF=36, SIZE=288 ou DURATION=5."
