
blog_uri = http:\/\/gholk.github.io

blog_filename = georeference-tilt-photo
blog_local_path = /home/gholk/gholk
source_html = $(blog_local_path)/$(blog_filename).html
source_text = $(blog_local_path)/text/$(blog_filename).txt

c34031328.zip: index.html README.pdf
	zip $@ * -x Des* -x $@ -x Makefile -x \*~ -x '#*'

README.pdf: index.html
	# add official url, css hide script and style, metadata
	emacsclient -c $<
	chromium $<
	# click Enter after chromium print pdf
	read w
	sed -i 's#file://$(PWD)#.#g' $@
	ghostscript -sDEVICE=pdfwrite -dPDFSETTINGS=/printer -dNOPAUSE -dQUIET -dBATCH -sOutputFile=- $@ | sponge $@

index.html: $(source_html)
	cp -f $< $@
	sed -i 's/="ext/="$(blog_uri)\/ext/' $@

$(source_html): $(source_text)
	cd $(blog_local_path)/system && make
