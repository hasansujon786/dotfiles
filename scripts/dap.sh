#!/bin/sh
# C:\Users\hasan\AppData\Local\nvim-data\dap_adapters
mkdir -p C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters\\
cd C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters\\

# dart
git clone https://github.com/Dart-Code/Dart-Code
cd Dart-Code
npx webpack --mode production

# node
git clone https://github.com/microsoft/vscode-node-debug2
cd vscode-node-debug2
npm install
NODE_OPTIONS=--no-experimental-fetch npm run build

