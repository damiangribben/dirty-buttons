#!/bin/sh
# Builds site/index.html (full document, for Vercel) from the root index.html (the Artifact source).
# index.html is written for the claude.ai Artifact publisher, which adds the document skeleton itself;
# this wraps it in a full document: everything up to </style> goes in <head>, the rest in <body>.
set -e
cd "$(dirname "$0")/.."
SRC=index.html
OUT=site/index.html
mkdir -p site

DESC="A skeuomorphic sampler panel whose pads, switches and dial get dirty and worn the more you touch them. Wipe it with the cloth or reset it."
ICON="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'%3E%3Ccircle cx='16' cy='16' r='14' fill='%232a2a2d' stroke='%230a0a0a' stroke-width='2'/%3E%3Ccircle cx='16' cy='16' r='6' fill='%236c6c70'/%3E%3Crect x='15' y='4' width='2' height='8' rx='1' fill='%23e9e2cf'/%3E%3C/svg%3E"

{
  printf '<!doctype html>\n<html lang="en">\n<head>\n'
  printf '<meta charset="utf-8">\n'
  printf '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n'
  printf '<meta name="description" content="%s">\n' "$DESC"
  printf '<meta name="theme-color" content="#121113">\n'
  printf '<meta property="og:title" content="Patina·7">\n'
  printf '<meta property="og:description" content="%s">\n' "$DESC"
  printf '<meta property="og:type" content="website">\n'
  printf '<link rel="icon" href="%s">\n' "$ICON"
  printf '<style>body{margin:0}[hidden]{display:none!important}</style>\n'
  awk '{ print } /<\/style>/ { exit }' "$SRC"
  printf '</head>\n<body>\n'
  awk 'found { print } /<\/style>/ { found = 1 }' "$SRC"
  printf '</body>\n</html>\n'
} > "$OUT"

echo "Wrote $OUT"
