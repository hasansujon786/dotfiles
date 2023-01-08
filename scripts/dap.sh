#!/bin/sh
# C:\Users\hasan\AppData\Local\nvim-data\dap_adapters
mkdir -p C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters\\

# dart
cd C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters\\
git clone https://github.com/Dart-Code/Dart-Code
cd Dart-Code
npx webpack --mode production

# vscode-js-debug
cd C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters\\
export VSCODE_JS_VER="1.72.0"
curl -O -J -L https://codeload.github.com/microsoft/vscode-js-debug/zip/refs/tags/v${VSCODE_JS_VER}
unzip vscode-js-debug-${VSCODE_JS_VER}.zip
mv vscode-js-debug-${VSCODE_JS_VER} vscode-js-debug && cd vscode-js-debug && npm install --legacy-peer-deps && npm run compile



# ========= depricated =========#
# # node
# cd C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters
# git clone https://github.com/microsoft/vscode-node-debug2
# cd vscode-node-debug2
# npm install
# NODE_OPTIONS=--no-experimental-fetch npm run build
# # chrome javascript
# cd C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters
# git clone https://github.com/Microsoft/vscode-chrome-debug
# cd vscode-chrome-debug
# npm install
# npm run build
