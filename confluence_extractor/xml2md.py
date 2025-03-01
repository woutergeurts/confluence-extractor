import lxml.etree as ET
import os 
import re
import logging
import pypandoc

# The default xsl is part of the package and is situated next to this .py file
DEFAULT_XSL=str(os.path.dirname(__file__))+"/confluence2md.xsl" 
PANDOC_XSL=str(os.path.dirname(__file__))+"/confluence2phtml.xsl" 
class Xml2Md:
    def __init__(self, xslt_file=DEFAULT_XSL,pandoc_processing=True):
        if pandoc_processing:
            xslt_file = PANDOC_XSL

        with open(xslt_file,"br") as f:
            self.xslt_content = f.read()
        self.pandoc_processing = pandoc_processing
        self.xslt_tree = ET.fromstring(self.xslt_content)

    def cleanup_md(md_contents: str) -> str:
        """
        clean up unnecessary white space (extra newlines, extra <br> in newlines)
        input: md-string
        returns: cleaned up string
        """
        text_br_removed = re.sub(r'\n\n(<br>)+', '\n\n', md_contents)
        text_br_and_lf_removed = re.sub(r'\n\n\n+', '\n\n', text_br_removed)
        return text_br_and_lf_removed
    
    def confluence_storage_to_xml(self,storage_xml_content: str):
        xml_content = """<?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE ac:confluence SYSTEM "confluence.dtd">
        <ac:confluence xmlns:ac="http://www.atlassian.com/schema/confluence/4/ac/" xmlns:ri="http://www.atlassian.com/schema/confluence/4/ri/" xmlns="http://www.atlassian.com/schema/confluence/4/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.atlassian.com/schema/confluence/4/ac/ confluence.xsd">
        """.encode()
        if type(storage_xml_content) == str:
           storage_xml_content = storage_xml_content.encode()     
        xml_content += storage_xml_content
        xml_content += b"</ac:confluence>"
        return xml_content
    
    def confluence_storage_to_md(self,storage_xml_content: str, pandoc_output="md"):
        """
        Transform the storage format to markdown. Note behavior is switched via the constructor
        pandoc_processing = True: pandoc is used for the transformation.
        pandoc_processing = False: md is generated via XSL file

        Args:
            storage_xml_content (bytes): confluence storage format as 
            pandoc_output (default 'md' conform the function all, if you p)

        Returns:
            str: The transformed MD content.
        """
        if not self.pandoc_processing:        
            return self.transform_confluence_storage(storage_xml_content)
        # else:
        phtml = self.confluence_storage_to_phtml(storage_xml_content)
        try:
            md_text = pypandoc.convert_text(phtml,format="html", to=pandoc_output)
        except Exception as e:
            logging.error(f"confluence_storage_to_{pandoc_output}: pandoc exception {e}")
        return md_text
    
    def confluence_storage_to_phtml(self,storage_xml_content: str):
        if not self.pandoc_processing: 
            logging.ERROR("use confluence_storage_to_phtml with pandoc_processing")
        return self.transform_confluence_storage(storage_xml_content)
    
    def phtml_to_md(self,phtml_content: str):
        if not self.pandoc_processing: 
            logging.ERROR("use phtml_to_md with pandoc_processing")    
        return self.transform_confluence_storage(phtml_content)

    def transform_confluence_storage(self,storage_xml_content: str):
        """
        Transforms an XML document using the stored XSLT.

        Args:
            storage_xml_content (bytes): confluence storage format

        Returns:
            str: The transformed MD content.
        """
        xml_content = self.confluence_storage_to_xml(storage_xml_content)
        
        return self.transform(xml_content)

    def transform(self, xml_content):
        """
        Helper function to transform an XML document using the stored XSLT.

        Args:
            xml_content (bytes): The XML content.

        Returns:
            str: The transformed content.
        """
        # Parse the XML and XSLT content
        xml_tree = ET.fromstring(xml_content)
        xslt_tree = self.xslt_tree

        # Create the XSLT transformer
        transform = ET.XSLT(xslt_tree)

        # Apply the transformation
        result_tree = transform(xml_tree)

        # Return the result as a string
        return str(result_tree)

if __name__ == "__main__":
    print("for testing: go to ../examples")
