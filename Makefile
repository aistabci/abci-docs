MKDOCS_ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SITE_DIR    := $(MKDOCS_ROOT)/site
COMMIT_ID   := $(shell git rev-parse --short HEAD)
NEWEST_TAG  := $(shell git describe --tags --abbrev=0)
CNAME       := docs.abci.ai

build:
	mkdocs build --config-file $(MKDOCS_ROOT)/root/mkdocs.yml --site-dir $(SITE_DIR)
	mkdocs build --config-file $(MKDOCS_ROOT)/ja/mkdocs.yml   --site-dir $(SITE_DIR)/ja/
	mkdocs build --config-file $(MKDOCS_ROOT)/en/mkdocs.yml   --site-dir $(SITE_DIR)/en/

	mkdocs build --config-file $(MKDOCS_ROOT)/portal/root/mkdocs.yml --site-dir $(SITE_DIR)/portal/
	mkdocs build --config-file $(MKDOCS_ROOT)/portal/ja/mkdocs.yml   --site-dir $(SITE_DIR)/portal/ja/
	mkdocs build --config-file $(MKDOCS_ROOT)/portal/en/mkdocs.yml   --site-dir $(SITE_DIR)/portal/en/

	mkdocs build --config-file $(MKDOCS_ROOT)/v3/root/mkdocs.yml --site-dir $(SITE_DIR)/v3/
	mkdocs build --config-file $(MKDOCS_ROOT)/v3/ja/mkdocs.yml   --site-dir $(SITE_DIR)/v3/ja/
	mkdocs build --config-file $(MKDOCS_ROOT)/v3/en/mkdocs.yml   --site-dir $(SITE_DIR)/v3/en/

	mkdocs build --config-file $(MKDOCS_ROOT)/v3/portal/root/mkdocs.yml --site-dir $(SITE_DIR)/v3/portal/
	mkdocs build --config-file $(MKDOCS_ROOT)/v3/portal/ja/mkdocs.yml   --site-dir $(SITE_DIR)/v3/portal/ja/
	mkdocs build --config-file $(MKDOCS_ROOT)/v3/portal/en/mkdocs.yml   --site-dir $(SITE_DIR)/v3/portal/en/

	mkdocs build --config-file $(MKDOCS_ROOT)/v3/operations-portal/ja/mkdocs.yml   --site-dir $(SITE_DIR)/v3/operations-portal/ja/

publish-head:
	ghp-import -m "deploy $(COMMIT_ID)" -c $(CNAME) -r origin -b gh-pages -p site

publish:
	ghp-import -m "deploy tag $(NEWEST_TAG)" -c $(CNAME) -r origin -b gh-pages -p site

clean:
	rm -rf  $(SITE_DIR)
