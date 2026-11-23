#!/bin/bash

cd "$(dirname "$0")" 2>/dev/null || exit 1

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "No es un repositorio Git"
  exit 1
fi

raiz=$(git rev-parse --show-toplevel 2>/dev/null) || exit 1
cd "$raiz" || exit 1

if [ -z "$(git config --get user.name 2>/dev/null)" ]; then
  git config --local user.name "$(whoami)" || exit 1
fi

if [ -z "$(git config --get user.email 2>/dev/null)" ]; then
  git config --local user.email "$(whoami)@local" || exit 1
fi

lista=()
for arch in ventas.sh script_semanal.sh; do
  if [ -f "$arch" ] && [ -n "$(git status --porcelain -- "$arch" 2>/dev/null)" ]; then
    lista+=("$arch")
  fi
done

if [ "${#lista[@]}" -eq 0 ]; then
  echo "Sin cambios en mis archivos"
  exit 0
fi

git add -- "${lista[@]}" || exit 1

if git diff --cached --quiet; then
  echo "Sin cambios en mis archivos"
  exit 0
fi

git commit -m "actualizacion semanal" || exit 1
echo "Commit realizado"
