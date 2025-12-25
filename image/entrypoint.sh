#!/usr/bin/env bash
set -Eeuo pipefail

# =========================
# Constantes
# =========================
STEAM_APP_ID="380870"

PZ_ROOT="/pz"
PZ_SYSTEM="${PZ_ROOT}/systeme"
STEAMCMD_DIR="${PZ_SYSTEM}/steamcmd"
PZ_SERVER_DIR="${PZ_SYSTEM}/server"
STEAMCMD_BIN="${STEAMCMD_DIR}/steamcmd.sh"

# =========================
# Variables utilisateur
# =========================
STEAM_BETA_BRANCH="${STEAM_BETA_BRANCH:-public}"
PZ_SERVER_NAME="${PZ_SERVER_NAME:-pzserver}"

# =========================
# Vérifications critiques
# =========================
if [[ -z "${PZ_ADMIN_PASSWORD:-}" ]]; then
  echo "[ERROR] PZ_ADMIN_PASSWORD is required" >&2
  exit 1
fi

if [[ ! -d "${PZ_ROOT}" ]]; then
  echo "[ERROR] /pz is not mounted" >&2
  exit 1
fi

# =========================
# Préparer arborescence
# =========================
mkdir -p \
  "${STEAMCMD_DIR}" \
  "${PZ_SERVER_DIR}" \
  "${PZ_ROOT}/Zomboid"

# =========================
# Installer SteamCMD si absent
# =========================
if [[ ! -x "${STEAMCMD_BIN}" ]]; then
  echo "[INFO] Installing SteamCMD"
  curl -fsSL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    | tar -xz -C "${STEAMCMD_DIR}"
fi

# =========================
# Mise à jour Project Zomboid (ORDRE CORRECT)
# =========================
echo "[INFO] Updating Project Zomboid Dedicated Server"
echo "[INFO] Steam beta branch: ${STEAM_BETA_BRANCH}"

"${STEAMCMD_BIN}" \
  +force_install_dir "${PZ_SERVER_DIR}" \
  +login anonymous \
  +app_update "${STEAM_APP_ID}" -beta "${STEAM_BETA_BRANCH}" validate \
  +quit

# =========================
# Vérification serveur
# =========================
START_SCRIPT="${PZ_SERVER_DIR}/start-server.sh"

if [[ ! -x "${START_SCRIPT}" ]]; then
  echo "[ERROR] start-server.sh not found or not executable" >&2
  exit 1
fi

# =========================
# Lancement serveur (PID 1)
# =========================
echo "[INFO] Starting Project Zomboid Dedicated Server"
echo "[INFO] Server name: ${PZ_SERVER_NAME}"

cd "${PZ_SERVER_DIR}"

exec ./start-server.sh \
  -servername "${PZ_SERVER_NAME}" \
  -adminpassword "${PZ_ADMIN_PASSWORD}"
