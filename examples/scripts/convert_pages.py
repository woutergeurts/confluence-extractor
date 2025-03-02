from confluence_extractor.xml2md import Xml2Md
from confluence_extractor.md2any import Md2Any
from confluence_extractor.config import Config
from confluence_extractor.doc_content import DocContent
import os
import fnmatch
import logging

logging.basicConfig(level=logging.INFO)
config = Config("examples/confluence_extractor.cfg")
xml2md = Xml2Md(pandoc_processing=False)
xml2xml_pandoc = Xml2Md(pandoc_processing=True)
md2any = Md2Any(config.docx_template, config.extract_dir)

# Pattern to match files
pattern = '*.storage.html'

old_wd = os.getcwd()
os.chdir("./examples/scripts")

# List all files in the directory
files = os.listdir(config.extract_dir)
#
# debug facility: add a real life example in the extract dir and put id here
#
id="225713012"
if id:
    files = [ f"{id}.storage.html" ]

matching_files = [
    file_name for file_name in files
        if fnmatch.fnmatch(file_name, pattern)
    ]

for filename in matching_files:
    confluence_storage_file = f"{config.extract_dir}/{filename}"
    logging.info(f"processing {confluence_storage_file}")

    try:
        with open(confluence_storage_file,"rb") as f:
            confluence_storage_input = f.read()
    
        md_file = confluence_storage_file.replace( "html", "md")
        md_text = xml2md.confluence_storage_to_md(confluence_storage_input)
    
        with open(md_file, "wb") as f:
            f.write(md_text.encode())

        md2any.md_to_docx(md_file)

        phtml_file = confluence_storage_file.replace( ".storage.html", ".conf-ext.html")
        md_file = confluence_storage_file.replace( ".storage.html", ".conf-ext.md")
        phtml_text = xml2xml_pandoc.confluence_storage_to_phtml(confluence_storage_input)
    
        with open(phtml_file, "wb") as f:
            f.write(phtml_text.encode())
    
        md_text = xml2xml_pandoc.confluence_storage_to_md(confluence_storage_input)
        doc_content = DocContent(config,md_text,"md")
        docx_file = md_file.replace(".md", ".docx")
        doc_content.format_to_file("docx",docx_file)


    except Exception as e:
        logging.error(f"An error occurred: on {confluence_storage_file} {e}")

os.chdir(old_wd)