#!/bin/bash

# ================================================
# Parrot OS Quick Setup Script - by @tuvieja
# Ejecutar con: curl -fsSL https://url-raw-del-script | bash
# ================================================

echo "🚀 Configurando Parrot OS a tu gusto rapidito..."

# 1. Añadir alias permanentes al ~/.bashrc
cat >> ~/.bashrc << 'EOF'

# === Mis alias de pentest rápidos ===
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'

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

# Actualizar sistema (Parrot/Kali)
updatekali() { 
    echo "Actualizando sistema..."
    sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y
}

# El famoso fuck (repetir último comando con sudo)
fuck() { 
    sudo $(history -p !!)
}

# Buscar procesos rápido
psg() { 
    [[ $# -eq 0 ]] && return 1
    ps aux | grep -v grep | grep -i --color=auto "$1"
}

# Matar proceso por nombre
ka() { 
    [[ $# -eq 0 ]] && return 1
    pkill -f "$1" && echo "Proceso $1 terminado." || echo "No se encontró $1"
}

EOF

# 2. Recargar .bashrc inmediatamente
source ~/.bashrc
echo "✅ Alias cargados y activados"

# 3. Descargar y poner fondo de pantalla (funciona en Parrot con XFCE)
WALLPAPER_DIR="$HOME/Imágenes"
WALLPAPER_PATH="$WALLPAPER_DIR/wallhaven-e8885k.png"
WALLPAPER_URL="https://w.wallhaven.cc/full/e8/wallhaven-e8885k.png"

mkdir -p "$WALLPAPER_DIR"

echo "⬇️ Descargando fondo de pantalla..."
if curl -fsSL "$WALLPAPER_URL" -o "$WALLPAPER_PATH"; then
    echo "🖼️ Aplicando fondo de pantalla..."
    # Método que funciona en Parrot OS (XFCE)
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitoreDP-1/workspace0/last-image -s "$WALLPAPER_PATH" 2>/dev/null
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorHDMI-1/workspace0/last-image -s "$WALLPAPER_PATH" 2>/dev/null
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$WALLPAPER_PATH" 2>/dev/null
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -s "$WALLPAPER_PATH" 2>/dev/null
    
    # Estilo: escalado
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitoreDP-1/workspace0/image-style -t int -s 3 2>/dev/null || true
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-style -t int -s 3 2>/dev/null || true
    echo "🖼️ Fondo de pantalla aplicado!"
else
    echo "❌ No se pudo descargar el fondo"
fi

# Mensaje final
echo ""
echo "🎉 ¡Todo listo!"
echo "   Los alias ya están activos en esta terminal"
echo "   Fondo de pantalla cambiado"
echo "   Para nuevas terminales, los alias se cargarán automáticamente"
echo ""
echo "Prueba algunos:"
echo "   nmapquick 10.10.10.10"
echo "   ffuf_web http://example.com /usr/share/wordlists/dirb/common.txt"
echo "   fuck   (cuando te olvides del sudo)"
echo ""
echo "¡Puto el que lee! 🏴‍☠️"

exit 0