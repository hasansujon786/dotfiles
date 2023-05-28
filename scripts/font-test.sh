#!/bin/sh

echo -e "\e[1mbold\e[0m"
echo -e "\e[3mitalic\e[0m"
echo -e "\e[3m\e[1mbold italic\e[0m"
echo -e "\e[4munderline\e[0m"
echo -e "\e[9mstrikethrough\e[0m"
echo -e "\e[31mHello World\e[0m"
echo -e "\x1B[31mHello World\e[0m"
printf "\x1b[58;2;255;0;0m\x1b[4msingle\x1b[21mdouble\x1b[60mcurly\x1b[61mdotted\x1b[62mdashed\x1b[0m"
