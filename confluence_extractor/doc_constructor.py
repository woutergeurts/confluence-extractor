# info in https://atlassian-python-api.readthedocs.io/

import re
import logging
from confluence_extractor.config import Config
from confluence_extractor.page import Page
from confluence_extractor.doc_content import DocContent

class DocConstructor:
    def __init__(self,config: Config, home_page: Page):
        self.extract_dir = config.extract_dir
        self.config = config
        self.home_page = home_page
        self.doc_content = DocContent(self.config)       

    def add_page_contents(self, page:Page, level=0):
        """
        Add another md file to the md_buffer

        note: run the hierarchy but filter on label = doc-ignore
         this ignores the current page AND the child pages
        """

        if self.config.ignore_label not in page.labels:
            md_header = "" 
            confluence_url = f"{self.config.base_url}/confluence/pages/viewpage.action?pageId={page.page_id}"  
            if level == 0:
                md_header += f"title: {page.title}\n\n"
            else:
                md_heading_tag = "#"*level
                md_header += f"\n\n{md_heading_tag} [{page.title}]({confluence_url})\n\n"
            
            self.doc_content.add_doc_part(md_header)

            try:
                self.doc_content.add_json_from_file(
                    f"{self.config.extract_dir}/{page.page_id}.conf-ext.json"
                    )
            except Exception as e:
                logging.error( f'add_page_contents: {page.page_id} ({page.title}) not found: exception {e}')
                          
            # this is intentionally indented in the 'if' to ignore subtrees
            for child_page in page.children:
                self.add_page_contents(child_page,level+1)            
    
    def add_json_for_page(self, page:Page, level:int):
        if page:
            self.add_page_contents(page,level)
        else:
            logging.error("page not found")
   
    def process_template(self,template_path,output_prefix=""):
        """
        Read template and act on special commands in comments:
         doc_constructor:include:confluence <page_id> <level> <title> => search page_id 
        """
        md_buffer = "" 
        with open(template_path, "r") as f:
            lines = f.readlines()
            for line in lines:
                md_buffer += line
                match = re.search(r"doc_constructor:include:confluence\s+(\d+)\s+(\d+)\s(.+)\s--", line)
                if match:
                    # first add md_buffer
                    self.doc_content.add_doc_part(md_buffer, "md")
                    md_buffer = ""
                    # now 
                    page_id = match.group(1)
                    level = int(match.group(2))
                    title = match.group(3)
                    import_page = self.home_page.find_by_id(page_id)
                    page_title = import_page.title
                    logging.info(f"importing page_id={page_id}, ({title}) ({page_title})")
                    # add page + childs
                    self.add_json_for_page(import_page,level)
                    
        # finally add residual buffer            
        self.doc_content.add_doc_part(md_buffer, "md")

    def md_to_docx(self, filename):
        self.doc_content.to_docx(filename)
               
if __name__ == "__main__":
    from config import Config
    config = Config()
    home_page = Page(0,"home")
    doc_constructor = DocConstructor(config,home_page)
    
