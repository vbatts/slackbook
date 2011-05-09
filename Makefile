# $Id$

chapters = chapter_*.xml

book.html: build.sh main.xml $(chapters)
	sh build.sh && \
	ls -l $@

book.pdf: main.xml $(chapters) .dblatex
	dblatex \
		--pdf \
		-x'-xinclude' \
		-o $@ \
		$<

view.pdf: book.pdf
	xdg-open $<

view.html: book.html
	xdg-open $<

.dblatex:
	which dblatex 2>/dev/null || echo "ERROR: 'dblatex' REQUIRED, SEE http://github.com/vbatts/SlackBuilds/ FOR THE SlackBuild"

.PHONY: clean
clean:
	rm -f book.html book.pdf

.DEFAULT_GOAL := book.html
