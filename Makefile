LANG = ja en

.PHONY: all $(LANG)

all: $(LANG)

$(LANG):
	make -C $@

install:
	sh ./deploy.sh

pdf:
	sh ./make_pdf.sh

install_pdf:
	sh ./deploy_pdf.sh
