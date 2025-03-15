# Technical stuff for development

## TODOs technical

The current setup still contains parts of the original idea: convert the storage.html to md via xslt. This approach hit bedrock with tables in combination with pieces of code in them, like an API description where you need to define the json payload. Cleanup is expected.

Only use the methods in the example scripts, the module internal methods are not yet marked with __. 

Decommission xml2md.py and md2any.py. 

## TODOs functionally

The following items need to be dealt with in xslt or cleanup:

* excess of white space (albeit, this is caused by information in confluence)
* use of special chars like ' (in varieties) and é.
* proper dealing with the 'code' macro
* nice to have: page links might be dealt with (either link to the confluence or within the document)
* nice to have: mark all used attachments, doing that you can remove the others and add/commit the source of your generated document
* roadmap (if needed): include external .md files via the template

# general design

## config.py

global configuration: every module uses the configuration.

## page_extractor.py / extract_pages.py

module to traverse the page hierarchy in confluence, get the corresponding .storage.html and attachments. As an extra service addition extractions and conversions are done per page. The page hierarchy is stored in the page_tree.json. 

Example use (copy this script to your own repo and connect the right dots with the .cfg file) is in [extract_pages.py](../examples/scripts/extract_pages.py)

## doc_constructor / template_to_doc.py

module to convert a template in markdown and include pages (and later e.g. markdown generated in the build process) convert this to a .docx (or if needed any supported pandoc output). 
Instead of documenting the doc constructor: please 

## doc_content.py

DocContent is a data class to hold (suprise) the doc content. Document pieces delivered in .md or .html or .json are stitched together using methods of this class. This class implements all the conversion to and from the pandoc .json format.

