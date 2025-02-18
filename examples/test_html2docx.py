import os
from confluence_extractor.config import Config
from confluence_extractor.xml2md import Xml2Md
from confluence_extractor.md2any import Md2Any
import logging

logging.basicConfig(level=logging.DEBUG)
config = Config()
xml2md = Xml2Md()

os.chdir("examples/scripts")
extract_dir = config.extract_dir
md2any = Md2Any(config.docx_template, extract_dir)

xml_file = '1000000.storage.html'
md_file = xml_file.replace('html','md')

with open(f"{extract_dir}/{xml_file}","rb") as f:
    xml_input = f.read()
    
output_txt = xml2md.confluence_storage_to_md(xml_input)

with open(f"{extract_dir}/{md_file}", "w") as f:
    f.write(output_txt)

md2any.md_to_docx(md_file)