#!/bin/sh
# $Id$

STYLE_SHEET="/usr/share/xml/docbook/xsl-stylesheets-1.75.1/html/docbook.xsl"
if [ ! -r "$STYLE_SHEET" ] ; then
  STYLE_SHEET=$(find /usr/share/xml -name docbook.xsl | grep /html/)
  printf "\nUsing $STYLE_SHEET \n"
fi

xsltproc \
  -xinclude \
  -o book.html \
  $STYLE_SHEET \
  main.xml
