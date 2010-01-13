#!/bin/sh
STYLE_SHEET="/usr/share/xml/docbook/xsl-stylesheets-1.75.1/html/docbook.xsl"

xsltproc \
  -xinclude \
  -o book.html \
  $STYLE_SHEET \
  main.xml
