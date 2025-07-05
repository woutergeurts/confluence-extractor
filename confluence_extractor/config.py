import configparser
import logging
DEFAULT_CONFIGFILE="examples/example_confluence_extractor.cfg"

class Config:
    def __init__(self,configfile=DEFAULT_CONFIGFILE):
        config = configparser.ConfigParser()
        files = config.read(configfile)
        if not files:
            logging.error(f"failed to read configfile {configfile}")
            return
        self.base_url = config.get('Confluence','server_url')
        self.confluence_token = config.get('Confluence','token')
        self.space_key = config.get('Confluence','space')
        self.extract_page_ids = config.get('Extractor','extract_page_ids').split(',')
        self.extract_dir = config.get('Extractor','extract_dir')
        self.resource_path = config.get('Extractor','resource_path')
        self.page_tree_file = config.get('Extractor','page_tree_file')
        self.docx_template = config.get('Constructor','docx_template')
        self.ignore_label = config.get('Constructor','ignore_label')

    def __str__(self):
        return f"space_key: {self.space_key}, extract_dir: {self.extract_dir} page_tree_file:{self.page_tree_file}"

if __name__ == "__main__":
    config = Config()
    print(config)