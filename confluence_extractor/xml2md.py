import lxml.etree as ET
import os 
import re

# The default xsl is part of the package and is situated next to this .py file
DEFAULT_XSL=str(os.path.dirname(__file__))+"/confluence2md.xsl" 
class Xml2Md:
    def __init__(self, xslt_file=DEFAULT_XSL):
        with open(xslt_file,"br") as f:
            self.xslt_content = f.read()

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
    
    def confluence_storage_to_md(self,storage_xml_content: str):
        """
        Transforms an XML document using the stored XSLT.

        Args:
            storage_xml_content (bytes): confluence storage format

        Returns:
            str: The transformed MD content.
        """
        xml_content = """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE ac:confluence SYSTEM "confluence.dtd">
<ac:confluence xmlns:ac="http://www.atlassian.com/schema/confluence/4/ac/" xmlns:ri="http://www.atlassian.com/schema/confluence/4/ri/" xmlns="http://www.atlassian.com/schema/confluence/4/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.atlassian.com/schema/confluence/4/ac/ confluence.xsd">
        """.encode()
        if type(storage_xml_content) == str:
           storage_xml_content = storage_xml_content.encode()     
        xml_content += storage_xml_content
        xml_content += b"</ac:confluence>"

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
