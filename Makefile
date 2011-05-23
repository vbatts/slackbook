# $Id$

chapters := $(wildcard chapter_*.xml)

imgs_ps := $(wildcard ps-imgs/*.eps)
imgs_png := $(addsuffix .png,$(addprefix png/,$(basename $(notdir $(imgs_ps)))))


list_imgs:
	@echo $(imgs_ps)
	@echo $(imgs_png)

define png_template
$(1): $(2)
	mkdir -p $(CWD)png && \
	convert -channel RGBA -density 196 $(2) -resample 72 -geometry 800x600 -trim +repage -flatten $(1)
endef
	#convert $(2) -geometry 800x600 -quality 100 -depth 24 -weight 10 -render -flatten $(1)

# this is a little voodoo, to iterate over the *.eps files, 
# and create a make target of the png output name, that will
# build those *.png files
# :) --vbatts
$(foreach ps,$(imgs_ps),$(eval $(call png_template,$(addsuffix .png,$(addprefix png/,$(basename $(notdir $(ps))))),$(ps))))

images: $(imgs_png)

book.html: build.sh main.xml $(chapters) $(imgs_png) .clean.html
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
	xdg-open $<

.dblatex:
	$(shell which dblatex 2>/dev/null >/dev/null || echo "ERROR: 'dblatex' REQUIRED, SEE http://github.com/vbatts/SlackBuilds/ FOR THE SlackBuild")


.PHONY: .clean.html
.clean.html:
	rm -f book.html

.PHONY: .clean.pdf
.clean.pdf:
	rm -f book.pdf

.PHONY: .clean.images
.clean.images:
	rm -fr png/

.PHONY: clean
clean: .clean.pdf .clean.html
	

.DEFAULT_GOAL := book.html

