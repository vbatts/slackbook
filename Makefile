# $Id$

chapters = chapter_*.xml

book.html: clean build.sh $(chapters)
	sh build.sh
	ls -l $@

.PHONY: clean
clean:
	rm -f book.html

.PHONY: view
view:
	xdg-open book.html

.DEFAULT_GOAL := book.html
