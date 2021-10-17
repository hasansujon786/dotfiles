# flatpak install flathub org.gimp.GIMP
wget -O PhotoGIMP.zip  https://github.com/Diolinux/PhotoGIMP/releases/download/1.0/PhotoGIMP.by.Diolinux.v2020.for.Flatpak.zip
unzip PhotoGIMP.zip && mv PhotoGIMP\ by\ Diolinux\ v2020\ for\ Flatpak ./PhotoGIMP
mkdir -p ~/.icons
sudo cp -r PhotoGIMP/.icons/photogimp.png ~/.icons/
sudo cp -r PhotoGIMP/.local/share/applications/org.gimp.GIMP.desktop ~/.local/share/applications/
sudo cp -r PhotoGIMP/.var/app/org.gimp.GIMP/ ~/.var/app/
