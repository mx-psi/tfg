PANDOC:=pandoc
# TODO: filters/IncludeFilter.hs
FILTERS:= filters/env.hs filters/pandoc-crossref pandoc-citeproc
PFLAGS:= $(foreach filter,$(FILTERS),-F $(filter)) -M commit="$$(git rev-parse --short HEAD)" -M time="$$(date -Iseconds)"
SRCS:= $(sort $(wildcard text/Mathematics/*.md)) $(sort $(wildcard text/CompSci/*.md))

.PHONY: all clean check

all: filters/pandoc-crossref tfg.pdf

filters/pandoc-crossref:
	wget https://github.com/lierdakil/pandoc-crossref/releases/download/v0.4.0.0-alpha2/linux-ghc84-pandoc22.tar.gz
	tar -xzf linux-ghc84-pandoc22.tar.gz
	cp pandoc-crossref filters/pandoc-crossref
	rm pandoc-crossref linux-ghc84-pandoc22.tar.gz pandoc-crossref.1

check: $(SRCS)
	proselint $^

tfg.pdf: $(SRCS) src/template.tex src/citas.bib
	$(PANDOC) $(PFLAGS) --template src/template.tex -H src/math.sty src/before.md $(SRCS) src/after.md -o $@

tfg.html: $(SRCS)
	$(PANDOC) $(PFLAGS) $(SRCS) -o $@

clean:
	rm tfg.pdf
