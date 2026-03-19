#!/bin/bash
cd "$(dirname "$0")"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# 1. Original dark bg, light text, green dot (already have this as logo-2048.png)

# 2. Transparent bg, light text, green dot
cat > _v.html << 'HTMLEOF'
<!DOCTYPE html><html><head><meta charset="UTF-8">
<style>
@font-face { font-family: 'Instrument Serif'; src: url('InstrumentSerif-Regular.ttf') format('truetype'); }
* { margin: 0; padding: 0; box-sizing: border-box; }
body { display: flex; align-items: center; justify-content: center; width: 2048px; height: 1000px; background: transparent; }
.logo { font-family: 'Instrument Serif', serif; font-size: 480px; letter-spacing: -0.02em; line-height: 1.2; padding: 40px; color: #e8e6e1; }
.logo span { color: #c4f74d; }
</style></head><body><div class="logo">Egbe<span>.</span></div></body></html>
HTMLEOF
"$CHROME" --headless --disable-gpu --virtual-time-budget=3000 --default-background-color=00000000 --screenshot="transparent-light-2048.png" --window-size=2048,1000 "file://$(pwd)/_v.html" 2>/dev/null
sips -z 488 1024 transparent-light-2048.png --out transparent-light-1024.png > /dev/null 2>&1
echo "Done: transparent-light"

# 3. Transparent bg, dark text, green dot
cat > _v.html << 'HTMLEOF'
<!DOCTYPE html><html><head><meta charset="UTF-8">
<style>
@font-face { font-family: 'Instrument Serif'; src: url('InstrumentSerif-Regular.ttf') format('truetype'); }
* { margin: 0; padding: 0; box-sizing: border-box; }
body { display: flex; align-items: center; justify-content: center; width: 2048px; height: 1000px; background: transparent; }
.logo { font-family: 'Instrument Serif', serif; font-size: 480px; letter-spacing: -0.02em; line-height: 1.2; padding: 40px; color: #08080a; }
.logo span { color: #c4f74d; }
</style></head><body><div class="logo">Egbe<span>.</span></div></body></html>
HTMLEOF
"$CHROME" --headless --disable-gpu --virtual-time-budget=3000 --default-background-color=00000000 --screenshot="transparent-dark-2048.png" --window-size=2048,1000 "file://$(pwd)/_v.html" 2>/dev/null
sips -z 488 1024 transparent-dark-2048.png --out transparent-dark-1024.png > /dev/null 2>&1
echo "Done: transparent-dark"

# 4. White bg, dark text, green dot
cat > _v.html << 'HTMLEOF'
<!DOCTYPE html><html><head><meta charset="UTF-8">
<style>
@font-face { font-family: 'Instrument Serif'; src: url('InstrumentSerif-Regular.ttf') format('truetype'); }
* { margin: 0; padding: 0; box-sizing: border-box; }
body { display: flex; align-items: center; justify-content: center; width: 2048px; height: 1000px; background: #ffffff; }
.logo { font-family: 'Instrument Serif', serif; font-size: 480px; letter-spacing: -0.02em; line-height: 1.2; padding: 40px; color: #08080a; }
.logo span { color: #c4f74d; }
</style></head><body><div class="logo">Egbe<span>.</span></div></body></html>
HTMLEOF
"$CHROME" --headless --disable-gpu --virtual-time-budget=3000 --screenshot="white-bg-2048.png" --window-size=2048,1000 "file://$(pwd)/_v.html" 2>/dev/null
sips -z 488 1024 white-bg-2048.png --out white-bg-1024.png > /dev/null 2>&1
echo "Done: white-bg"

# 5. Dark bg, all white (monochrome)
cat > _v.html << 'HTMLEOF'
<!DOCTYPE html><html><head><meta charset="UTF-8">
<style>
@font-face { font-family: 'Instrument Serif'; src: url('InstrumentSerif-Regular.ttf') format('truetype'); }
* { margin: 0; padding: 0; box-sizing: border-box; }
body { display: flex; align-items: center; justify-content: center; width: 2048px; height: 1000px; background: #08080a; }
.logo { font-family: 'Instrument Serif', serif; font-size: 480px; letter-spacing: -0.02em; line-height: 1.2; padding: 40px; color: #ffffff; }
.logo span { color: #ffffff; }
</style></head><body><div class="logo">Egbe<span>.</span></div></body></html>
HTMLEOF
"$CHROME" --headless --disable-gpu --virtual-time-budget=3000 --screenshot="mono-white-2048.png" --window-size=2048,1000 "file://$(pwd)/_v.html" 2>/dev/null
sips -z 488 1024 mono-white-2048.png --out mono-white-1024.png > /dev/null 2>&1
echo "Done: mono-white"

# 6. White bg, all black (monochrome)
cat > _v.html << 'HTMLEOF'
<!DOCTYPE html><html><head><meta charset="UTF-8">
<style>
@font-face { font-family: 'Instrument Serif'; src: url('InstrumentSerif-Regular.ttf') format('truetype'); }
* { margin: 0; padding: 0; box-sizing: border-box; }
body { display: flex; align-items: center; justify-content: center; width: 2048px; height: 1000px; background: #ffffff; }
.logo { font-family: 'Instrument Serif', serif; font-size: 480px; letter-spacing: -0.02em; line-height: 1.2; padding: 40px; color: #08080a; }
.logo span { color: #08080a; }
</style></head><body><div class="logo">Egbe<span>.</span></div></body></html>
HTMLEOF
"$CHROME" --headless --disable-gpu --virtual-time-budget=3000 --screenshot="mono-black-2048.png" --window-size=2048,1000 "file://$(pwd)/_v.html" 2>/dev/null
sips -z 488 1024 mono-black-2048.png --out mono-black-1024.png > /dev/null 2>&1
echo "Done: mono-black"

# Cleanup
rm -f _v.html
echo "All done!"
