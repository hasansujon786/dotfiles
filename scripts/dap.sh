#!/bin/sh
# C:\Users\hasan\AppData\Local\nvim-data\dap_adapters
mkdir -p C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters\\

# dart
cd C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters\\
git clone https://github.com/Dart-Code/Dart-Code
cd Dart-Code
npx webpack --mode production

# node
cd C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters
git clone https://github.com/microsoft/vscode-node-debug2
cd vscode-node-debug2
npm install
NODE_OPTIONS=--no-experimental-fetch npm run build

# chrome javascript
cd C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters
git clone https://github.com/Microsoft/vscode-chrome-debug
cd vscode-chrome-debug
npm install
npm run build
