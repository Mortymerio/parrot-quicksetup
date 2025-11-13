#!/usr/bin/env bash
# ================================================
# Parrot OS Quick Setup Script - by @tuvieja & Mortymerio
# Versión corregida 2025 – funciona en Bash 5.x sin errores
# Ejecutar con:
# bash <(curl -fsSL https://raw.githubusercontent.com/Mortymerio/parrot-quicksetup/main/parrot-setup.sh)
# ================================================

# ---------- Colores (compatible Bash 5.x) ----------
RESET="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
BOLD="\033[1m"

# ---------- Funciones de ayuda ----------
print_banner() {
    clear
    echo -e "${RED}"
    echo "   ____   __    __   ____   ____  _____  ____   __  __  ____  ____  ____ "
    echo "  |    \ |  |  |  | |    \ |    \|     ||    \ |  \/  ||    ||    \|    \ "
    echo "  |  o  )|  |  |  | |  D  )|  o  )   __||  o  )|      ||  o  )  o  )  o  )"
    echo "  |     ||  |  |  | |    / |   _/|  |   |     ||  |\_  ||     |     |     |"
    echo "  |  O  ||  :  :  | |    \ |  |  |  |   |  O  ||  |  | ||  O  |  O  |  O  |"
    echo "  |_____||___\___\__||_____||__|  |__|   |_____||__|__||_____||_____||_____|${RESET}"
    echo ""
    echo -e "${YELLOW}          Configurando Parrot OS a tu gusto rapidito...${RESET}"
    echo ""
}

progress() {
    echo -ne "${CYAN}[*] $1...${RESET}"
}

success() {
    echo -e "${GREEN} ✔${RESET}"
}

# ---------- Inicio ----------
print_banner

progress "Añadiendo alias permanentes a ~/.bashrc"
cat >> ~/.bashrc << 'EOF'

# === Mis alias de pentest rápidos (by @tuvieja) ===
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'
alias ka='pkill -f'
alias psg='ps aux | grep -v grep | grep -i --color=auto'

nmapquick() { 
    [[ $# -eq 0 ]] && { echo "Uso: nmapquick IP"; return 1; }
    nmap -sV -sC -T4 "$1"
}

nmapfull() { 
    [[ $# -eq 0 ]] && { echo "Uso: nmapfull IP"; return 1; }
    sudo nmap -p- -sV -sC -O --min-rate 1000 --max-retries 2 "$1"
}

gobuster_dir() { 
    [[ $# -lt 2 ]] && { echo "Uso: gobuster_dir URL WORDLIST"; return 1; }
    gobuster dir -u "$1" -w "$2" -q -t 50 -k -x php,html,txt,bak,zip
}

ffuf_web() { 
    [[ $# -lt 2 ]] && { echo "Uso: ffuf_web URL WORDLIST"; return 1; }
    ffuf -u "$1/FUZZ" -w "$2" -mc 200,301,302,303,401 -c -t 100
}

sqlmap_quick() { 
    [[ $# -eq 0 ]] && { echo "Uso: sqlmap_quick URL"; return 1; }
    sqlmap -u "$1" --batch --random-agent --risk=3 --level=3
}

nikto_scan() { 
    [[ $# -eq 0 ]] && { echo "Uso: nikto_scan URL"; return 1; }
    nikto -h "$1" -Tuning x
}

updatekali() { 
    echo "Actualizando sistema..."
    sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y
}

fuck() { 
    sudo $(history -p !!)
}

EOF
success

progress "Recargando .bashrc"
source ~/.bashrc >/dev/null 2>&1
success

progress "Descargando fondo de pantalla hacker"
WALLPAPER_DIR="$HOME/Imágenes"
WALLPAPER_PATH="$WALLPAPER_DIR/wallhaven-hacker.png"
WALLPAPER_URL="https://w.wallhaven.cc/full/e8/wallhaven-e8885k.png"

mkdir -p "$WALLPAPER_DIR"
if curl -fsSL "$WALLPAPER_URL" -o "$WALLPAPER_PATH"; then
    # Aplicar en todos los monitores posibles (XFCE - Parrot OS)
    for monitor in eDP-1 HDMI-1 DP-1 monitor0 monitorVirtual1; do
        xfconf-query -c xfce4-desktop -p /backdrop/screen0/$monitor/workspace0/last-image -s "$WALLPAPER_PATH" 2>/dev/null || true
        xfconf-query -c xfce4-desktop -p /backdrop/screen0/$monitor/workspace0/image-style -t int -s 3 2>/dev/null || true
    done
    success
    echo -e "${GREEN}Fondo de pantalla aplicado!${RESET}"
else
    echo -e "${RED}No se pudo descargar el fondo${RESET}"
fi

# ---------- Final ----------
echo ""
echo -e "${BOLD}${MAGENTA}¡TODO LISTO, CRACK!${RESET}"
echo -e "${WHITE}   Los alias ya están activos en esta terminal${RESET}"
echo -e "${WHITE}   Abre una nueva terminal y prueba:${RESET}"
echo -e "${CYAN}      nmapquick 10.10.10.10${RESET}"
echo -e "${CYAN}      ffuf_web http://example.com /usr/share/wordlists/dirb/common.txt${RESET}"
echo -e "${CYAN}      fuck   ← cuando te olvides el sudo${RESET}"
echo ""
echo -e "${BOLD}${RED}¡Puto el que lee! 🏴‍☠️${RESET}"
echo ""

exit 0
