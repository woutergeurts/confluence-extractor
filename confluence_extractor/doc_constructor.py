# info in https://atlassian-python-api.readthedocs.io/

import re
import logging
from confluence_extractor.config import Config
from confluence_extractor.page import Page
from confluence_extractor.xml2md import Xml2Md

class DocConstructor:
    def __init__(self,config: Config, home_page: Page):
        self.extract_dir = config.extract_dir
        self.config = config
        self.home_page = home_page       

    def add_md_contents(self, page:Page, level=0):
        """
        Add another md file to the md_buffer

        note: run the hierarchy but filter on label = doc-ignore
         this ignores the current page AND the child pages
        """

        if self.config.ignore_label not in page.labels:
            
            confluence_url = f"{self.config.base_url}/confluence/pages/viewpage.action?pageId={page.page_id}"  
            if level == 0:
                self.md_buffer += f"title: {page.title}\n\n"
            else:
                md_heading_tag = "#"*level
                self.md_buffer += f"\n\n{md_heading_tag} [{page.title}]({confluence_url})\n\n"
            
            try:
                with open(f"{self.config.extract_dir}/{page.page_id}.storage.md", "r", encoding="utf-8") as f:
                    md_contents = f.read()
            except Exception as e:
                logging.error( f'add_md_contents: {page.page_id} ({page.title}) not found: exception {e}')
                md_contents = f"Page {page.page_id} (md) not found"
            self.md_buffer += md_contents
            
            # this is intentionally indented in the 'if' to ignore subtrees
            for child_page in page.children:
                self.add_md_contents(child_page,level+1)            
    
    def to_file(self,filename):

        output = Xml2Md().cleanup_md(self.md_buffer)
        with open(filename, "w", encoding="utf-8") as f:
            f.write(output)

    def get_md_for_page(self, page:Page, level:int):
        if page:
            self.md_buffer = "" 
            self.add_md_contents(page,level)
        else:
            logging.error("page not found")
            self.md_buffer = "\n\n# ERROR: page not found\n\n"
        return self.md_buffer
   
    def process_template(self,template_path,output_prefix):
        """
        Read template and act on special commands in comments:
         doc_constructor:include:confluence <page_id> <level> <title> => search page_id 
        """
        with open(template_path, "r") as f:
            with open(f"{output_prefix}.md", "w") as md:
                lines = f.readlines()
                for line in lines:
                    md.write(line)
                    match = re.search(r"doc_constructor:include:confluence\s+(\d+)\s+(\d+)\s(.+)\s--", line)
                    if match:
                        page_id = match.group(1)
                        level = int(match.group(2))
                        title = match.group(3)
                        import_page = self.home_page.find_by_id(page_id)
                        page_title = import_page.title
                        logging.info(f"importing page_id={page_id}, ({title}) ({page_title})")

                        md.write(self.get_md_for_page(import_page,level))
                        md.write("\n")
               
if __name__ == "__main__":
    from config import Config
    config = Config()
    home_page = Page(0,"home")
    doc_constructor = DocConstructor(config,home_page)
    
