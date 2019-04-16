PANDOC:=pandoc
# TODO: filters/IncludeFilter.hs
FILTERS:= filters/env.hs filters/pandoc-crossref pandoc-citeproc
PFLAGS:= $(foreach filter,$(FILTERS),-F $(filter)) -M commit="$$(git rev-parse --short HEAD)" -M time="$$(date -Iseconds)"
SRCS:= text/Mathematics/quantum_mechanics.md text/CompSci/classic_computation.md text/CompSci/probabilistic_computation.md text/CompSci/quantum_computation.md text/CompSci/qft.md

.PHONY: all clean check

all: filters/pandoc-crossref tfg.pdf

filters/pandoc-crossref:
	wget https://github.com/lierdakil/pandoc-crossref/releases/download/v0.4.0.0-alpha2/linux-ghc84-pandoc22.tar.gz
	tar -xzf linux-ghc84-pandoc22.tar.gz
	cp pandoc-crossref filters/pandoc-crossref
	rm pandoc-crossref linux-ghc84-pandoc22.tar.gz pandoc-crossref.1

check: $(SRCS) #tfg.html
	proselint $^
#	linkchecker --check-extern --timeout=35 --ignore-url=web.archive.org --ignore-url=stackexchange.com --ignore-url=stackoverflow.com tfg.html

tfg.pdf: $(SRCS) src/template.tex src/citas.bib
	$(PANDOC) $(PFLAGS) --template src/template.tex -H src/math.sty src/before.md $(SRCS) src/after.md -o $@

%.html: %.md
	$(PANDOC) $(PFLAGS) $< -o $@

clean:
	rm tfg.pdf
