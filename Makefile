PANDOC:=pandoc
FILTERS:= filters/IncludeFilter.hs filters/env.hs filters/pandoc-crossref pandoc-citeproc
PFLAGS:= --top-level-division=chapter $(foreach filter,$(FILTERS),-F $(filter)) -H header.sty -M commit="$$(git rev-parse --short HEAD)" -M time="$$(date -Iseconds)"


.PHONY: all clean

all: tfg.pdf tufte.pdf

tufte.pdf: tfg.md tufte.tex citas.bib
	$(PANDOC) $(PFLAGS) --template tufte.tex $< -o $@

%.pdf: %.md template.tex citas.bib
	$(PANDOC) $(PFLAGS) --template template.tex $< -o $@

clean:
	rm tfg.pdf tufte.pdf
