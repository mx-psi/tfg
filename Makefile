PANDOC:=pandoc
# TODO: filters/IncludeFilter.hs
FILTERS:= filters/env.hs filters/pandoc-crossref pandoc-citeproc
PFLAGS:= $(foreach filter,$(FILTERS),-F $(filter)) -M commit="$$(git rev-parse --short HEAD)" -M time="$$(date -Iseconds)"
SRCS:= text/Mathematics/quantum_mechanics.md


.PHONY: all clean check

all: filters/pandoc-crossref tfg.pdf

filters/pandoc-crossref:
	wget https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.0.1/linux-ghc82-pandoc20.tar.gz
	tar -xzf linux-ghc82-pandoc20.tar.gz
	cp pandoc-crossref filters/pandoc-crossref
	rm pandoc-crossref linux-ghc82-pandoc20.tar.gz pandoc-crossref.1

check: tfg.md #tfg.html
	proselint tfg.md
#	linkchecker --check-extern --timeout=35 --ignore-url=web.archive.org --ignore-url=stackexchange.com --ignore-url=stackoverflow.com tfg.html

tfg.pdf: $(SRCS) src/template.tex src/citas.bib
	$(PANDOC) $(PFLAGS) -H src/math.sty --template src/template.tex src/before.md $< src/after.md -o $@

%.html: %.md
	$(PANDOC) $(PFLAGS) $< -o $@

clean:
	rm tfg.pdf
