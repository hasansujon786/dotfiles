#!/bin/bash

WINPATH="${1//\//\\}"
explorer /select,"$WINPATH"
sleep 3
