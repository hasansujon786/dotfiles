USERNAME=$(whoami)

mkdir -p "/c/Users/$USERNAME/AppData/Local/clangd"

cat >"/c/Users/$USERNAME/AppData/Local/clangd/config.yaml" <<EOF
CompileFlags:
  Compiler: C:/Users/$USERNAME/scoop/apps/mingw/current/bin/g++.exe
EOF
