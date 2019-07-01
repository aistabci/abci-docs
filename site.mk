MKDOCS_ROOT := $(dir $(lastword $(MAKEFILE_LIST)))
SITE_DIR := $(MKDOCS_ROOT)/site

all:
	mkdocs build --config-file $(MKDOCS_ROOT)/root/mkdocs.yml --site-dir ../site/
	mkdocs build --config-file $(MKDOCS_ROOT)/ja/mkdocs.yml --site-dir ../site/ja/
	mkdocs build --config-file $(MKDOCS_ROOT)/en/mkdocs.yml --site-dir ../site/en/

clean:
	echo rm -rf  $(SITE_DIR)
