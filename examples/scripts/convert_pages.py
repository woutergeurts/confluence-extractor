from confluence_extractor.xml2md import Xml2Md
from confluence_extractor.md2any import Md2Any
from confluence_extractor.config import Config
import os
import fnmatch
import logging

logging.basicConfig(level=logging.INFO)
config = Config("examples/confluence_extractor.cfg")
xml2md = Xml2Md()
md2any = Md2Any(config.docx_template, config.extract_dir)

# Pattern to match files
pattern = '*.storage.html'

old_wd = os.getcwd()
os.chdir("./examples/scripts")

# List all files in the directory
files = os.listdir(config.extract_dir)
matching_files = [
    file_name for file_name in files
        if fnmatch.fnmatch(file_name, pattern)
    ]

for filename in matching_files:
    confluence_storage_file = f"{config.extract_dir}/{filename}"
    logging.info(f"processing {confluence_storage_file}")

    try:
        output_file = confluence_storage_file.replace( "html", "md")
        with open(confluence_storage_file,"rb") as f:
            confluence_storage_input = f.read()
    
        output_txt = xml2md.confluence_storage_to_md(confluence_storage_input)
    
        with open(output_file, "wb") as f:
            f.write(output_txt.encode())

        md2any.md_to_docx(output_file)
    
    except Exception as e:
        logging.error(f"An error occurred: on {confluence_storage_file} {e}")

os.chdir(old_wd)