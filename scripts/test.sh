#!/bin/bash

# Funktion "initial"
initial() {
    echo "Hallo"
}

# Funktion "change"
change() {
    echo "Tschüss"
}

# Prüfen, ob ein Parameter übergeben wurde
if [ "$1" == "initial" ]; then
    initial
elif [ "$1" == "change" ]; then
    change
else
    echo "Bitte 'initial' oder 'change' als Parameter verwenden."
fi