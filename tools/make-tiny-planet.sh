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
#   - réduit à 480x480 (net jusqu'à ~160px d'affichage sur écran retina)
#   - coupe l'audio (l'icône est muette — obligatoire pour l'autoplay navigateur)
#   - limite la durée (une icône n'a pas besoin de 2 minutes de vidéo)
#
# Prérequis : ffmpeg (déjà installé via Homebrew sur cette machine).

set -euo pipefail

SRC="${1:-}"
DURATION="${DURATION:-8}"   # secondes conservées, depuis START
START="${START:-0}"         # début de l'extrait dans la source
SIZE="${SIZE:-480}"         # côté du carré de sortie, en pixels

if [[ -z "$SRC" ]]; then
  echo "Usage : $0 <fichier-video-source>" >&2
  echo "Options (variables d'environnement) : START=0 DURATION=8 SIZE=480" >&2
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
echo "Sortie     : ${OUT_DIR}/tiny-planet.{mp4,webm,jpg} (${SIZE}x${SIZE})"
echo

echo "→ MP4 (H.264)…"
ffmpeg -v error -stats -y \
  -ss "$START" -i "$SRC" -t "$DURATION" \
  -vf "$FILTER" \
  -an \
  -c:v libx264 -profile:v main -pix_fmt yuv420p \
  -crf 30 -preset slow -movflags +faststart \
  "${OUT_DIR}/tiny-planet.mp4"

echo "→ Poster (JPEG)…"
ffmpeg -v error -y \
  -ss "$START" -i "$SRC" -frames:v 1 \
  -vf "crop='min(iw,ih)':'min(iw,ih)',scale=${SIZE}:${SIZE}" \
  -q:v 4 \
  "${OUT_DIR}/tiny-planet.jpg"

echo
echo "Terminé :"
ls -lh "${OUT_DIR}"/tiny-planet.* | awk '{print "  " $9 "  " $5}'
echo
echo "Ce repo est public : garder ces fichiers légers (viser < 1,5 Mo au total)."
echo "Trop lourd ? relancer avec DURATION=5 ou SIZE=360."
