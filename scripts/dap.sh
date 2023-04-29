#!/bin/sh
# C:\Users\hasan\AppData\Local\nvim-data\dap_adapters
mkdir -p C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters\\

# dart
cd C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters\\
export DART_CODE_VER="3.56.0"
curl -O -J -L https://codeload.github.com/Dart-Code/Dart-Code/zip/refs/tags/v${DART_CODE_VER}
unzip Dart-Code-${DART_CODE_VER}.zip && mv Dart-Code-${DART_CODE_VER} Dart-Code && cd Dart-Code
npm install && npm run build
cd .. && rm Dart-Code-${DART_CODE_VER}.zip

# vscode-js-debug
cd C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters\\
export VSCODE_JS_VER="1.78.0"
curl -O -J -L https://codeload.github.com/microsoft/vscode-js-debug/zip/refs/tags/v${VSCODE_JS_VER}
unzip vscode-js-debug-${VSCODE_JS_VER}.zip && mv vscode-js-debug-${VSCODE_JS_VER} vscode-js-debug && cd vscode-js-debug
npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out
cd .. && rm vscode-js-debug-${VSCODE_JS_VER}.zip


