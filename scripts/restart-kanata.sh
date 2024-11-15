#!/bin/bash

taskkill //IM "kanata-tray.exe" //IM "kanata.exe" //F
sleep 0.3
explorer "C:\\Users\\hasan\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\kanata-tray.exe"
