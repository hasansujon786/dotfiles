#!/bin/sh

# https://www.reddit.com/r/elementaryos/comments/p40rm5/using_kde_connect_on_elementary_os_6_odin/

# wingpanel dependencies
sudo apt-get install libwingpanel-dev indicator-application -y
wget https://github.com/Lafydev/wingpanel-indicator-ayatana/raw/master/com.github.lafydev.wingpanel-indicator-ayatana_2.0.8_odin.deb
sudo dpkg -i com.github.lafydev.wingpanel-indicator-ayatana_2.0.8_odin.deb

sudo apt install kdeconnect -y
# flatpack install com.github.bajoja.indicator_kdeconnect.Locale

mkdir -p ~/.config/autostart
cp /etc/xdg/autostart/indicator-application.desktop ~/.config/autostart/
sed -i 's/^OnlyShowIn.*/OnlyShowIn=Unity;GNOME;Pantheon;/' ~/.config/autostart/indicator-application.desktop

