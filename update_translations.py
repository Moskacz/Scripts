#!/usr/bin/python
import sys
import os
import shutil

if len(sys.argv) < 3:
    print('invalid arguments, please specify source folder as 1st argument and destination as 2nd')
    exit()

supportedLanguages = ['de', 'en', 'es', 'fr', 'it', 'pl', 'pt', 'ro', 'ru']
fromLocationBase = sys.argv[1]
toLocationBase = sys.argv[2]

for language in supportedLanguages:
    source = fromLocationBase + "/" + language + ".lproj" + "/" + "Localizable.strings"
    destination = toLocationBase + "/" + language + ".lproj" + "/" + "Localizable.strings"
    if os.path.isfile(source):
        shutil.move(source, destination)