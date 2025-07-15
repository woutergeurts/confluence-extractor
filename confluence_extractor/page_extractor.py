# info in https://atlassian-python-api.readthedocs.io/
import re
from atlassian import Confluence
import logging

from confluence_extractor.xml2md import Xml2Md
from confluence_extractor.page import Page
from confluence_extractor.config import Config

class PageExtractor:
    def __init__(self,config: Config, verify_ssl=True):
        base_url = config.base_url
        confluence_token = config.confluence_token
        self.space_key = config.space_key
        self.extract_dir = config.extract_dir
        
        self.confluence = Confluence(
           url=f"{base_url}/confluence",
           token=confluence_token,
           verify_ssl = verify_ssl)
        
        self.xml2md = Xml2Md()
    
    def replace_image_tag_by_sourcefile(self, phtml: str) -> str:
        # Replace <ac:image><ri:attachment ri:filename="..."/></ac:image> with <img src="..."/>

        #example input: <p><ac:image><ri:attachment ri:filename="image-2025-7-10_12-5-25.png"/></ac:image></p>
        #example output: <p><img xmlns="" src="image-2025-7-10_12-5-25.png"/></p>
        return re.sub(
            r'<ac:image>\s*<ri:attachment\s+ri:filename="([^"]+)"\s*/>\s*</ac:image>',
            r'<img src="\1"/>',
            phtml
        )

    def clean_string(self,txt:str):
        """
        Replace unicode strings that mess with libraries
            TODO Up arrow (↑): &uarr;
            TODO Down arrow (↓): &darr;
            TODO Left arrow (←): &larr;
            TODO Right arrow (→): &rarr;
            TODO Double headed arrow (↔): &harr;
        """
        # txt = txt.replace('\u2192',"&rarr;") # ->
        #txt = txt.replace('\u2003',"U2003")
        txt = txt.replace("\u00A0"," ")
        txt = self.replace_image_tag_by_sourcefile(txt)
        return(txt)
 
   
    def get_label_list(self, page_id):
        label_list = []
        confluence_labels = self.confluence.get_page_labels(page_id)
        for result in confluence_labels['results']:
            label_list.append(result['name'])

        return label_list
    
    def add_page(self,parent_page:Page,page_id,extract_files=False,extract_attachments=False):
                  
        confluence_page = self.confluence.get_page_by_id(page_id,expand='body.storage,body.view,body.external_view')
        title = confluence_page['title']
        page_id = confluence_page['id']
        label_list = self.get_label_list(page_id)
        page = Page(page_id,title,label_list)
        parent_page.add_child(page)

        logging.info( f'add_page: {title} ({page_id})' )
 
        if extract_files:
            try: 
                with open(f"{self.extract_dir}/{page_id}.storage.html", "w", encoding="utf-8") as f:
                    f.write(self.clean_string(confluence_page['body']['storage']['value']))

                with open(f"{self.extract_dir}/{page_id}.view.html", "w", encoding="utf-8") as f:
                    f.write(self.clean_string(confluence_page['body']['view']['value']))

                with open(f"{self.extract_dir}/{page_id}.pdf", "bw") as f:
                    f.write(self.confluence.get_page_as_pdf(page_id))

            except Exception as e:
                logging.error( f'write of {page_id} ({title}) failed: exception {e}')
            
            try:
                for format in ["md", "json"]:
                    with open(f"{self.extract_dir}/{page_id}.conf-ext.{format}", "w", encoding="utf-8") as f:
                        f.write(self.xml2md.confluence_storage_to_md(
                            self.clean_string(confluence_page['body']['storage']['value']),format))
                    
            except Exception as e:
                logging.error( f'md write of {page_id} ({title}) failed: exception {e}')
 
        if extract_attachments:
            try: 
                self.confluence.download_attachments_from_page(page_id, self.extract_dir)
                                                    
            except Exception as e:
                logging.error( f'download van attachments of {page_id} ({title}) failed: exception {e}')

        children = self.confluence.get_child_pages(page_id)
        for child in children:
            child_id = child["id"]
            self.add_page(page,child_id,extract_files,extract_attachments)
