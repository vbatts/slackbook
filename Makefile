# $Id$

chapters = chapter_*.xml

book.html: build.sh $(chapters)
	sh build.sh && \
	ls -l $@

.PHONY: clean
clean:
	rm -f book.html

view: book.html
	xdg-open book.html

.DEFAULT_GOAL := book.html
