LISP=/usr/bin/pil
LISP_LIB=/usr/lib/picolisp/lib.l

SRC=resume.l html.l
DEST_HTML_RU=resume-ru.html
DEST_HTML_EN=resume-en.html

all : $(DEST_HTML_RU) $(DEST_HTML_EN)

$(DEST_HTML_RU) : $(SRC)
	$(LISP) $(LISP_LIB) -"eval '(setq lang-current 'ru)" $< > $@

$(DEST_HTML_EN) : $(SRC)
	$(LISP) $(LISP_LIB) -"eval '(setq lang-current 'en)" $< > $@
