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
2. (with poetry installed) poetry install
3. poetry run pip install lxml # install lxml manually with pip, the poetry does not work
4. ctrl-shift-P - select interpreter

### test it
From the repository root, run the example conversion script:

```powershell
poetry run python examples/test_html2docx.py
```

The script converts `examples/extract/1000000.storage.html` to Markdown and
DOCX files in `examples/extract`. The Markdown conversion applies the
`confluence_extractor/filters/unwrap_content_wrapper.lua` Pandoc filter. This
removes Confluence's presentational `content-wrapper` divs, so the generated
Markdown does not contain Pandoc fenced-div markers such as `:::` and remains
readable by Visual Studio and other standard Markdown editors.

The same conversion is used when extracting pages with
`examples/scripts/extract_pages.py`. To run that workflow after configuring
`examples/confluence_extractor.cfg`:

```powershell
poetry run python examples/scripts/extract_pages.py
```

## use it

### general
A working setup has been created in the example dir. See the scripts

```
./example/scripts/extract_pages.py
./example/scripts/template_to_doc.py
```

In a confluence environment a series of pages has been made and extracted. The extracted files have been formatted (they come out without newlines). 

In order to use this package, you need to setup up a similar structure of directories and scripts.

### steps TODO TEST

1. copy example_confluence_extractor.cfg to confluence_extractor.cfg
2. fill it out with your connection details
    1. it is good practice to change 'extract' to 'extract_test'
    2. this dir is already excluded in .gitignore
    3. mkdir test_extract 
3. choose a page within your space to be used and add a pageid in the cfg
4. test it: (poetry run python examples/scripts/extract_pages.py) 
5. copy example_Architecture_template.md to example_test_template.md
6. modify test_template.md: insert your pageid of point 3
7. mkdir example/results (if not present)
8. test it: (poetry run python examples/scripts/template_to_doc.py)
