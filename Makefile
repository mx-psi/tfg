PANDOC:=pandoc
# TODO: filters/IncludeFilter.hs
FILTERS:= filters/env.hs filters/pandoc-crossref pandoc-citeproc
PFLAGS:= $(foreach filter,$(FILTERS),-F $(filter)) -M commit="$$(git rev-parse --short HEAD)" -M time="$$(date -Iseconds)" -H src/math.sty

MATH:= $(sort $(wildcard text/Mathematics/*.md))
CSI:= $(sort $(wildcard text/CompSci/*.md))

PREV:= $(patsubst %.md, text/Others/%.md, 01-summary.md 02-intro.md)
POST:= $(patsubst %.md, text/Others/%.md, 03-conclusions.md 04-appendix.md)

CHAPTERS:= $(patsubst text/Mathematics/%.md, chapters/%.pdf, $(MATH)) $(patsubst text/CompSci/%.md, chapters/%.pdf, $(CSI))
SRCS:= $(PREV) $(MATH) $(CSI) $(POST)


.PHONY: all clean check

all: filters/pandoc-crossref $(CHAPTERS)

filters/pandoc-crossref:
	wget https://github.com/lierdakil/pandoc-crossref/releases/download/v0.4.0.0-alpha2/linux-ghc84-pandoc22.tar.gz
	tar -xzf linux-ghc84-pandoc22.tar.gz
	cp pandoc-crossref filters/pandoc-crossref
	rm pandoc-crossref linux-ghc84-pandoc22.tar.gz pandoc-crossref.1

check: $(SRCS)
	proselint $^

tfg.pdf: $(SRCS) src/template.tex src/citas.bib
	$(PANDOC) $(PFLAGS) --template src/template.tex src/before.md $(SRCS) src/after.md -o $@

chapters/%.pdf: text/Mathematics/%.md
	$(PANDOC) $(PFLAGS) -M title=$(patsubst text/Mathematics/%.md,%, $^) --template src/chapter.tex src/before-chap.md $^ src/after.md -o $@

chapters/%.pdf: text/CompSci/%.md
	$(PANDOC) $(PFLAGS) -M title=$(patsubst text/CompSci/%.md,%, $^) --template src/chapter.tex src/before-chap.md $^ src/after.md -o $@

tfg.html: $(SRCS)
	$(PANDOC) $(PFLAGS) $(SRCS) -o $@

clean:
	rm tfg.pdf
