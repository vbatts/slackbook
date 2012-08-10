# $Id$

chapters := $(wildcard chapter_*.xml)

imgs_ps := $(wildcard ps-imgs/*.eps)
imgs_png := $(addsuffix .png,$(addprefix png/,$(basename $(notdir $(imgs_ps)))))


list_imgs:
	@echo $(imgs_ps)
	@echo $(imgs_png)

# cleaning up the voodoo a bit.
# now it matches a pattern instead of generating a bunch of rules
# -- vbatts
png/%.png: ps-imgs/%.eps .convert
	mkdir -p $(CWD)png && \
	convert -channel RGBA -density 196 $< -resample 72 -geometry 800x600 -trim +repage -flatten $@

dummy:
	convert $(2) -geometry 800x600 -quality 100 -depth 24 -weight 10 -render -flatten $(1)

images: $(imgs_ps)

#book.html: build.sh main.xml $(chapters) $(imgs_png) .clean.html
book.html: build.sh main.xml $(chapters) $(imgs_png)
	sh build.sh && \
	ls -l $@

book.pdf: main.xml $(chapters) $(imgs_png) .dblatex .clean.pdf
	dblatex \
		--pdf \
		-x'-xinclude' \
		-o $@ \
		$<

view.pdf: book.pdf
	xdg-open $<

view.html: book.html
	xdg-open $< || links $<

.PHONY: view
view: view.html

.convert:
	@which convert 2>/dev/null >/dev/null || echo "ERROR: 'convert' REQUIRED, this is in imagemagick" && touch $@

.dblatex:
	@which dblatex 2>/dev/null >/dev/null || echo "ERROR: 'dblatex' REQUIRED, SEE http://github.com/vbatts/SlackBuilds/ FOR THE SlackBuild" && touch $@


.PHONY: .clean.html
.clean.html:
	rm -f book.html

.PHONY: .clean.pdf
.clean.pdf:
	rm -f book.pdf

.PHONY: .clean.stuff
.clean.stuff:
	rm -fr .convert .dblatex

.PHONY: .clean.images
.clean.images:
	rm -fr png/

.PHONY: dist-clean clean
dist-clean: clean .clean.images .clean.stuff

clean: .clean.pdf .clean.html 
	

.DEFAULT_GOAL := book.html

