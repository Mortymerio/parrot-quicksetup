#!/usr/bin/env bash
# Parrot OS Quick Setup 2025 – VERSIÓN DEFINITIVA (no duplica + refresh automático)
# Ejecutar con:
# bash <(curl -fsSL https://raw.githubusercontent.com/Mortymerio/parrot-quicksetup/main/parrot-setup.sh)

set -euo pipefail

# ---------- Colores ----------
RESET="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
MAGENTA="\033[35m"
BOLD="\033[1m"

clear
echo -e "${RED}   ____   __    __   ____   ____  _____  ____   __  __  ____  ____  ____ "
echo -e "  |    \\ |  |  |  | |    \\ |    \\|     ||    \\ |  \\/  ||    ||    \\|    \\ "
echo -e "  |  o  )|  |  |  | |  D  )|  o  )   __||  o  )|      ||  o  )  o  )  o  )${RESET}"
echo -e "${YELLOW}          Configurando Parrot OS a tu gusto rapidito...${RESET}"
echo

# ---------- 1. Añadir alias solo si NO existen ya ----------
BASHRC="$HOME/.bashrc"
MARKER_START="# === Mis alias de pentest rápidos (parrot-quicksetup) ==="
MARKER_END="# === FIN alias parrot-quicksetup ==="

if grep -q "$MARKER_START" "$BASHRC" 2>/dev/null; then
    echo -e "${YELLOW}Los alias ya están instalados. Saltando...${RESET}"
else
    echo -e "${CYAN}Instalando alias permanentes...${RESET}"
    cat >> "$BASHRC" << EOF

$MARKER_START
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'
alias ka='pkill -f'
alias psg='ps aux | grep -v grep | grep -i --color=auto'

nmapquick() { [[ \$# -eq 0 ]] && { echo "Uso: nmapquick IP"; return 1; }; nmap -sV -sC -T4 "\$1"; }
nmapfull() { [[ \$# -eq 0 ]] && { echo "Uso: nmapfull IP"; return 1; }; sudo nmap -p- -sV -sC -O --min-rate 1000 --max-retries 2 "\$1"; }
gobuster_dir() { [[ \$# -lt 2 ]] && { echo "Uso: gobuster_dir URL WORDLIST"; return 1; }; gobuster dir -u "\$1" -w "\$2" -q -t 50 -k -x php,html,txt,bak,zip; }
ffuf_web() { [[ \$# -lt 2 ]] && { echo "Uso: ffuf_web URL WORDLIST"; return 1; }; ffuf -u "\$1/FUZZ" -w "\$2" -mc 200,301,302,303,401 -c -t 100; }
sqlmap_quick() { [[ \$# -eq 0 ]] && { echo "Uso: sqlmap_quick URL"; return 1; }; sqlmap -u "\$1" --batch --random-agent --risk=3 --level=3; }
nikto_scan() { [[ \$# -eq 0 ]] && { echo "Uso: nikto_scan URL"; return 1; }; nikto -h "\$1" -Tuning x; }
updatekali() { echo "Actualizando sistema..."; sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y; }
fuck() { sudo \$(history -p !!); }
$MARKER_END
EOF
    echo -e "${GREEN}Alias instalados${RESET}"
fi

# ---------- 2. Fondo de pantalla ----------
echo -e "${CYAN}Configurando fondo de pantalla hacker...${RESET}"
mkdir -p ~/Imágenes
WP="$HOME/Imágenes/wallhaven-hacker.png"
if [[ ! -f "$WP" ]]; then
    curl -fsSL https://w.wallhaven.cc/full/e8/wallhaven-e8885k.png -o "$WP" >/dev/null 2>&1 && echo -e "${GREEN}Fondo descargado${RESET}" || echo -e "${RED}Falló descarga${RESET}"
else
    echo -e "${YELLOW}Fondo ya existe, saltando descarga${RESET}"
fi

# Aplicar en todos los monitores posibles
for m in eDP-1 HDMI-1 DP-1 monitor0 monitorVirtual1; do
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/$m/workspace0/last-image -s "$WP" 2>/dev/null || true
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/$m/workspace0/image-style -t int -s 3 2>/dev/null || true
done

# ---------- 3. Refresh inmediato de la terminal actual ----------
echo -e "${CYAN}Refrescando esta terminal...${RESET}"
source "$BASHRC" 2>/dev/null || true
exec bash  # ¡¡ESTO ES LO QUE QUERÍAS!! reemplaza el shell actual → los alias ya funcionan ahora mismo

# (el exec hace que el script termine aquí y el nuevo bash tome el control)
