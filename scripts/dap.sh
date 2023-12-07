#!/bin/sh
# C:\Users\hasan\AppData\Local\nvim-data\dap_adapters
mkdir -p C:\\Users\\$USERNAME\\AppData\\Local\\nvim-data\\dap_adapters\\

# vscode-js-debug
cd C:\\Users\\$USERNAME\\AppData\\Local\\nvim-data\\dap_adapters\\
export VSCODE_JS_VER="1.85.0"
rm -rf vscode-js-debug
curl -O -J -L https://codeload.github.com/microsoft/vscode-js-debug/zip/refs/tags/v${VSCODE_JS_VER}
unzip vscode-js-debug-${VSCODE_JS_VER}.zip && mv vscode-js-debug-${VSCODE_JS_VER} vscode-js-debug && cd vscode-js-debug
npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out
cd .. && rm vscode-js-debug-${VSCODE_JS_VER}.zip


# # dart
# cd C:\\Users\\$USERNAME\\AppData\\Local\\nvim-data\\dap_adapters\\
# export DART_CODE_VER="3.56.0"
# curl -O -J -L https://codeload.github.com/Dart-Code/Dart-Code/zip/refs/tags/v${DART_CODE_VER}
# unzip Dart-Code-${DART_CODE_VER}.zip && mv Dart-Code-${DART_CODE_VER} Dart-Code && cd Dart-Code
# npm install && npm run build
# cd .. && rm Dart-Code-${DART_CODE_VER}.zip

