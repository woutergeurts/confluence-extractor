# confluence_extractor

## goal

If you document your (software) project using confluence and need to build neat (word) documents to hand over to a third party. This repo provides modules support you with it.

## approach

build scripts to

* extract page tree's from confluence using the api
* convert the individual pages to markdown
* cat the pages to a total markdown file
* convert to your favourite (latex) or third party required (docx) format usint pandoc

## getting started

### setup the config

You can use poetry to setup an environment that contains all the necessary actions. This works for me ...."

```
cd <your path to confluence_extractor>
code .
```
1. Open a terminal
2. insatll lxml manually with pip, the poetry does not work
3. (with poetry installed) poetry install
4. ctrl-shift-P - select interpreter

### test it
in code: go to examples dir and run the test_xml2md.py, it converts the html file to md and docx (at least it should)

## use it

A working setup has been created in the example dir. See the scripts

```
./example/scripts/extract_pages.py
./example/scripts/template_to_doc.py
```

In a confluence environment a series of pages has been made and extracted. The extracted files have been formatted (they come out without newlines). 

In order to use this package, you need to setup up a similar structure of directories and scripts.