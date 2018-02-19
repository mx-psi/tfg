PANDOC:=pandoc
FILTERS:= filters/IncludeFilter.hs filters/env.hs filters/pandoc-crossref pandoc-citeproc
PFLAGS:= --top-level-division=chapter $(foreach filter,$(FILTERS),-F $(filter)) -M commit="$$(git rev-parse --short HEAD)" -M time="$$(date -Iseconds)"


.PHONY: all clean check

all: tfg.pdf tufte.pdf

check: tfg.html
	proselint tfg.md
	linkchecker --check-extern --timeout=35 --ignore-url=web.archive.org --ignore-url=stackexchange.com --ignore-url=stackoverflow.com tfg.html

tufte.pdf: tfg.md tufte.tex citas.bib
	$(PANDOC) $(PFLAGS) -H header.sty --template tufte.tex $< -o $@

%.pdf: %.md template.tex citas.bib
	$(PANDOC) $(PFLAGS) -H header.sty --template template.tex $< -o $@

%.html: %.md
	$(PANDOC) $(PFLAGS) $< -o $@

clean:
	rm tfg.pdf tufte.pdf
