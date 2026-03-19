#!/bin/bash
cd "$(dirname "$0")"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

OUTDIR="${1:-2K}"
SIZE="${2:-2048}"
FONT_SIZE=$((SIZE * 480 / 2048))
BODY_H=$((SIZE * 1000 / 2048))
PAD=$((SIZE * 60 / 2048))

mkdir -p "$OUTDIR"

render() {
    local name="$1" bg="$2" color="$3" dot="$4" chrome_bg="${5:-}"
    cat > _v.html << HTMLEOF
<!DOCTYPE html><html><head><meta charset="UTF-8">
<style>
@font-face { font-family: 'Instrument Serif'; src: url('InstrumentSerif-Regular.ttf') format('truetype'); }
* { margin: 0; padding: 0; box-sizing: border-box; }
body { display: flex; align-items: center; justify-content: center; width: ${SIZE}px; height: ${BODY_H}px; background: ${bg}; }
.logo { font-family: 'Instrument Serif', serif; font-size: ${FONT_SIZE}px; letter-spacing: -0.02em; line-height: 1.2; padding: 40px; color: ${color}; }
.logo span { color: ${dot}; }
</style></head><body><div class="logo">Egbe<span>.</span></div></body></html>
HTMLEOF
    if [ -n "$chrome_bg" ]; then
        "$CHROME" --headless --disable-gpu --virtual-time-budget=3000 --default-background-color="$chrome_bg" --screenshot="${OUTDIR}/${name}-${SIZE}.png" --window-size=${SIZE},${BODY_H} "file://$(pwd)/_v.html" 2>/dev/null
    else
        "$CHROME" --headless --disable-gpu --virtual-time-budget=3000 --screenshot="${OUTDIR}/${name}-${SIZE}.png" --window-size=${SIZE},${BODY_H} "file://$(pwd)/_v.html" 2>/dev/null
    fi

    # Trim then add padding
    if [ -n "$chrome_bg" ] && [ "$chrome_bg" = "00000000" ]; then
        magick "${OUTDIR}/${name}-${SIZE}.png" -trim -bordercolor none -border ${PAD} +repage "${OUTDIR}/${name}-${SIZE}.png" 2>/dev/null
    else
        magick "${OUTDIR}/${name}-${SIZE}.png" -trim -bordercolor "${bg}" -border ${PAD} +repage "${OUTDIR}/${name}-${SIZE}.png" 2>/dev/null
    fi

    echo "Done: ${name}"
}

# 1. Original dark bg, light text, green dot
render "logo" "#08080a" "#e8e6e1" "#c4f74d"

# 2. Transparent bg, light text, green dot
render "transparent-light" "transparent" "#e8e6e1" "#c4f74d" "00000000"

# 3. Transparent bg, dark text, green dot
render "transparent-dark" "transparent" "#08080a" "#c4f74d" "00000000"

# 4. White bg, dark text, green dot
render "white-bg" "#ffffff" "#08080a" "#c4f74d"

# 5. Dark bg, all white (monochrome)
render "mono-white" "#08080a" "#ffffff" "#ffffff"

# 6. White bg, all black (monochrome)
render "mono-black" "#ffffff" "#08080a" "#08080a"

# 7. Accent bg (green), dark text
render "accent-bg" "#c4f74d" "#08080a" "#08080a"

# 8. Accent bg, white text
render "accent-bg-white" "#c4f74d" "#ffffff" "#ffffff"

# 9. Dark bg, accent text (all green)
render "dark-accent" "#08080a" "#c4f74d" "#c4f74d"

# 10. Dark bg, light text, white dot
render "dark-whitedot" "#08080a" "#e8e6e1" "#e8e6e1"

# 11. Transparent, accent text (all green)
render "transparent-accent" "transparent" "#c4f74d" "#c4f74d" "00000000"

# 12. Navy bg, light text, green dot
render "navy-bg" "#0a1628" "#e8e6e1" "#c4f74d"

# 13. Gray bg, dark text, green dot
render "gray-bg" "#f0f0ec" "#08080a" "#c4f74d"

rm -f _v.html
echo "All done!"
