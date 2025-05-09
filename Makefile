MAIN = main
NAME = ustcthesis
CLSFILES = $(NAME).cls
BSTFILES = $(NAME)-numerical.bst $(NAME)-authoryear.bst $(NAME)-bachelor.bst

SHELL = bash
LATEXMK = latexmk -xelatex
VERSION = $(shell cat $(NAME).cls | egrep -o "\\ustcthesisversion{[0-9.]+[0-9a-z.-]*" \
	  | egrep -o "[0-9.]+[0-9a-z.-]*")
TEXMF = $(shell kpsewhich --var-value TEXMFHOME)

.PHONY : main cls doc test save clean all install distclean zip FORCE_MAKE

main : $(MAIN).pdf

all : main doc

cls : $(CLSFILES) $(BSTFILES)

doc : $(NAME)-doc.pdf

$(MAIN).pdf : $(MAIN).tex $(CLSFILES) $(BSTFILES) FORCE_MAKE
	$(LATEXMK) $<

$(NAME)-doc.pdf : $(NAME)-doc.tex FORCE_MAKE
	$(LATEXMK) $<

test:
	l3build check

save:
	bash test/save.sh

clean : FORCE_MAKE
	$(LATEXMK) -c $(MAIN).tex $(NAME)-doc.tex

cleanall :
	$(LATEXMK) -C $(MAIN).tex $(NAME)-doc.tex

install : cls doc
	mkdir -p $(TEXMF)/{doc,source,tex}/latex/$(NAME)
	mkdir -p $(TEXMF)/bibtex/bst/$(NAME)
	cp $(BSTFILES) $(TEXMF)/bibtex/bst/$(NAME)
	cp $(NAME)-doc.pdf $(TEXMF)/doc/latex/$(NAME)/$(NAME).pdf
	cp $(CLSFILES) $(TEXMF)/tex/latex/$(NAME)

zip : main doc
	ln -sf . $(NAME)
	zip -r $(NAME)-v$(VERSION).zip $(NAME)/{*.md,LICENSE,\
	$(NAME)-doc.tex,$(NAME)-doc.pdf,$(NAME).cls,*.bst,*.bbx,*.cbx,figures,\
	$(MAIN).tex,ustcsetup.tex,chapters,bib,$(MAIN).pdf,\
	latexmkrc,Makefile}
	rm $(NAME)
