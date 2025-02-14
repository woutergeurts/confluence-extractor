import os
import logging

from confluence_extractor.page_extractor import PageExtractor
from confluence_extractor.page import Page
from confluence_extractor.config import Config

logging.basicConfig(level=logging.INFO )

# construct this page with your own pointer to confluence!
config = Config("examples/confluence_extractor.cfg")
extractor = PageExtractor(config)
home_page = Page(0, "home")

old_wd = os.getcwd()
os.chdir("./examples/scripts")
for page_id in config.extract_page_ids:
    extractor.add_page(home_page, page_id, True,True)

home_page.log_tree()        
home_page.dump(config.page_tree_file)
os.chdir(old_wd)