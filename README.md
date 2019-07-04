# README

The primary goal of this project is to organize a concerted community effort to improve the ABCI Users Guide that explains how to utilize [AI Bridging Cloud Infrastructure (ABCI)](https://abci.ai/). ABCI is the world's first large-scale Open AI Computing Infrastructure, constructed and operated by [National Institute of Advanced Industrial Science and Technology (AIST)](https://www.aist.go.jp/).  We would welcome your feedbacks including pull requests.

On every *release* we will deploy it as the current *official* version of the ABCI User Guide, which is located at [https://portal.abci.ai/docs/](https://portal.abci.ai/docs/).

## Structure of the repository

This repository consists of three [MkDocs](https://www.mkdocs.org/) documents:

| Directory | officially deployed URL | Notes |
|:--|:--|:--|
| root/ | https://portal.abci.ai/docs/    | Document root of the ABCI User Guide |
| ja/   | https://portal.abci.ai/docs/ja/ | Japanese version |
| en/   | https://portal.abci.ai/docs/en/ | English version |
| portal/root/ | https://portal.abci.ai/docs/    | Document root of the ABCI Portal Guide |
| portal/ja/   | https://portal.abci.ai/docs/ja/ | Japanese version |
| portal/en/   | https://portal.abci.ai/docs/en/ | English version |

## Development

You can clone the repository to your local environment and run the builtin development server.

```
$ pip install mkdocs
$ pip install mkdocs-material
$ git clone https://github.com/aistairc/abci-user-manual.git
$ cd abci-user-manual
$ cd root/ or ja/ or en/
$ mkdocs serve
```

And, open 'http://127.0.0.1:8000/' using a web browser.

## Build

You can build the static version of three documents.

```
$ make -f site.mk
```
