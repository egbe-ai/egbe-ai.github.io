#!/bin/bash
cd "$(dirname "$0")"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

render() {
    local name="$1" bg="$2" color="$3" dot="$4" chrome_bg="${5:-}"
    cat > _v.html << HTMLEOF
<!DOCTYPE html><html><head><meta charset="UTF-8">
<style>
@font-face { font-family: 'Instrument Serif'; src: url('InstrumentSerif-Regular.ttf') format('truetype'); }
* { margin: 0; padding: 0; box-sizing: border-box; }
body { display: flex; align-items: center; justify-content: center; width: 2048px; height: 1000px; background: ${bg}; }
.logo { font-family: 'Instrument Serif', serif; font-size: 480px; letter-spacing: -0.02em; line-height: 1.2; padding: 40px; color: ${color}; }
.logo span { color: ${dot}; }
</style></head><body><div class="logo">Egbe<span>.</span></div></body></html>
HTMLEOF
    if [ -n "$chrome_bg" ]; then
        "$CHROME" --headless --disable-gpu --virtual-time-budget=3000 --default-background-color="$chrome_bg" --screenshot="${name}-2048.png" --window-size=2048,1000 "file://$(pwd)/_v.html" 2>/dev/null
    else
        "$CHROME" --headless --disable-gpu --virtual-time-budget=3000 --screenshot="${name}-2048.png" --window-size=2048,1000 "file://$(pwd)/_v.html" 2>/dev/null
    fi
    sips -z 488 1024 "${name}-2048.png" --out "${name}-1024.png" > /dev/null 2>&1
    echo "Done: ${name}"
}

# Accent bg (green), dark text, dark dot
render "accent-bg" "#c4f74d" "#08080a" "#08080a"

# Accent bg, white text, white dot
render "accent-bg-white" "#c4f74d" "#ffffff" "#ffffff"

# Dark bg, accent text (all green)
render "dark-accent" "#08080a" "#c4f74d" "#c4f74d"

# Dark bg, light text, white dot (no accent)
render "dark-whitedot" "#08080a" "#e8e6e1" "#e8e6e1"

# Transparent, accent text (all green)
render "transparent-accent" "transparent" "#c4f74d" "#c4f74d" "00000000"

# Navy bg, light text, green dot
render "navy-bg" "#0a1628" "#e8e6e1" "#c4f74d"

# Gray bg, dark text, green dot
render "gray-bg" "#f0f0ec" "#08080a" "#c4f74d"

rm -f _v.html
echo "All done!"
