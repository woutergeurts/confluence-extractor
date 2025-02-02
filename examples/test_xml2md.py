from src.config import Config
from src.xml2md import Xml2Md
from src.md2any import Md2Any
import logging

logging.basicConfig(level=logging.DEBUG)
config = Config()
xml2md = Xml2Md()
extract_dir = "./examples"
md2any = Md2Any(config.docx_template, extract_dir)

xml_file = '1000000.storage.html'
md_file = xml_file.replace('html','md')

with open(f"{extract_dir}/{xml_file}","rb") as f:
    xml_input = f.read()
    
output_txt = xml2md.transform(xml_input)

with open(f"{extract_dir}/{md_file}", "w") as f:
    f.write(output_txt)

md2any.md_to_docx(md_file)