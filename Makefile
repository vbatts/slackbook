# $Id$

chapters = chapter_*.xml

book.html: build.sh main.xml $(chapters)
	sh build.sh && \
	ls -l $@

book.pdf: main.xml $(chapters)
	dblatex \
		--pdf \
		-x'-xinclude' \
		-o $@ \
		$<

view.pdf: book.pdf
	xdg-open $<

view.html: book.html
	xdg-open $<

.PHONY: clean
clean:
	rm -f book.html book.pdf

.DEFAULT_GOAL := book.html
