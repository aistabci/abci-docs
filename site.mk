MKDOCS_ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SITE_DIR    := $(MKDOCS_ROOT)/site
COMMIT_ID   := $(shell git rev-parse --short HEAD)
CNAME       := docs.abci.ai

build:
	mkdocs build --config-file $(MKDOCS_ROOT)/root/mkdocs.yml --site-dir $(SITE_DIR)
	mkdocs build --config-file $(MKDOCS_ROOT)/ja/mkdocs.yml   --site-dir $(SITE_DIR)/ja/
	mkdocs build --config-file $(MKDOCS_ROOT)/en/mkdocs.yml   --site-dir $(SITE_DIR)/en/

	mkdocs build --config-file $(MKDOCS_ROOT)/portal/root/mkdocs.yml --site-dir $(SITE_DIR)/portal/
	mkdocs build --config-file $(MKDOCS_ROOT)/portal/ja/mkdocs.yml   --site-dir $(SITE_DIR)/portal/ja/
	mkdocs build --config-file $(MKDOCS_ROOT)/portal/en/mkdocs.yml   --site-dir $(SITE_DIR)/portal/en/

publish:
	ghp-import -m "deploy $(COMMIT_ID)" -c $(CNAME) -r origin -b gh-pages -p site

clean:
	rm -rf  $(SITE_DIR)
