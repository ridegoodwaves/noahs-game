#!/usr/bin/env bash
# Download Godot + export templates, then headless-export Web preset "Web" → dist/web/
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "${ROOT}/scripts/godot-version.env"

CACHE="${HOME}/.cache/noahs-game-godot"
mkdir -p "${CACHE}" "${ROOT}/dist/web"

REL_TAG="${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}"
VERSION_LABEL="Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}"

OS="$(uname -s)"
ARCH="$(uname -m)"

download() {
  local url="$1"
  local out="$2"
  if [[ -f "${out}" ]]; then
    echo "Using cached: ${out}"
    return 0
  fi
  echo "Downloading ${url}"
  curl -fsSL "${url}" -o "${out}"
}

BASE_URL="https://github.com/godotengine/godot/releases/download/${REL_TAG}"

case "${OS}" in
  Linux)
    if [[ "${ARCH}" != "x86_64" && "${ARCH}" != "amd64" ]]; then
      echo "Unsupported Linux arch: ${ARCH} (official builds are x86_64)" >&2
      exit 1
    fi
    ZIP_NAME="${VERSION_LABEL}_linux.x86_64.zip"
    EDIT_SUBPATH="${VERSION_LABEL}_linux.x86_64"
    ;;
  Darwin)
    ZIP_NAME="${VERSION_LABEL}_macos.universal.zip"
    EDIT_SUBPATH="Godot.app/Contents/MacOS/Godot"
    ;;
  *)
    echo "Unsupported OS: ${OS} (add Windows mapping if needed)" >&2
    exit 1
    ;;
esac

ZIP_PATH="${CACHE}/${ZIP_NAME}"
download "${BASE_URL}/${ZIP_NAME}" "${ZIP_PATH}"

TMP_UNZIP="${CACHE}/godot_editor_${REL_TAG}"
rm -rf "${TMP_UNZIP}"
mkdir -p "${TMP_UNZIP}"
unzip -q -o "${ZIP_PATH}" -d "${TMP_UNZIP}"

GODOT_PATH="${TMP_UNZIP}/${EDIT_SUBPATH}"
if [[ ! -x "${GODOT_PATH}" ]]; then
  GODOT_PATH="$(find "${TMP_UNZIP}" -maxdepth 3 -type f \( -name "${VERSION_LABEL}_linux.x86_64" -o -name 'Godot' \) | head -1)"
fi
chmod +x "${GODOT_PATH}"

TPZ_NAME="${VERSION_LABEL}_export_templates.tpz"
TPZ_PATH="${CACHE}/${TPZ_NAME}"
download "${BASE_URL}/${TPZ_NAME}" "${TPZ_PATH}"

EXPORT_TEMPLATE_ROOT="${HOME}/.local/share/godot/export_templates"
TMP_TPZ="${CACHE}/tpz_extract_${REL_TAG}"
rm -rf "${TMP_TPZ}"
mkdir -p "${TMP_TPZ}"
unzip -q -o "${TPZ_PATH}" -d "${TMP_TPZ}"
if [[ ! -d "${TMP_TPZ}/templates" ]]; then
  echo "Unexpected export_templates.tpz layout (missing templates/)" >&2
  exit 1
fi

TEMPLATE_VERSION="$(tr -d '\r\n' < "${TMP_TPZ}/templates/version.txt")"
TEMPLATE_DEST="${EXPORT_TEMPLATE_ROOT}/${TEMPLATE_VERSION}"
rm -rf "${TEMPLATE_DEST}"
mkdir -p "${TEMPLATE_DEST}"
cp -a "${TMP_TPZ}/templates/." "${TEMPLATE_DEST}/"

echo "Godot: $("${GODOT_PATH}" --version)"
echo "Templates: ${TEMPLATE_DEST} ($(wc -c < "${TEMPLATE_DEST}/version.txt" | tr -d ' ') bytes version.txt)"
echo "Exporting Web → ${ROOT}/dist/web/index.html ..."
"${GODOT_PATH}" --headless --path "${ROOT}" --export-release "Web" "${ROOT}/dist/web/index.html"

if [[ ! -f "${ROOT}/dist/web/index.html" ]]; then
  echo "Export failed: dist/web/index.html missing" >&2
  exit 1
fi
echo "Web export OK: ${ROOT}/dist/web/"
