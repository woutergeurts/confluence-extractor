import os
from confluence_extractor.config import Config
from confluence_extractor.page import Page
from confluence_extractor.doc_constructor import DocConstructor
import logging

logging.basicConfig(level=logging.DEBUG )
config = Config("./examples/confluence_extractor.cfg")

os.chdir("examples/scripts")
home_page = Page.undump(config.page_tree_file)

template_dir="../doc-templates"
output_dir="../results"
doclist = [ "Architecture", "Maintenance" ]

home_page.log_tree()

for doc in doclist:
    doc_constructor = DocConstructor(config, home_page)
    template_path=f"{template_dir}/example_{doc}_template.md"
    output_prefix=f"{output_dir}/{doc}"
    logging.info(f"start processing: {doc} template={template_path} output_dir={output_dir}")

    doc_constructor.process_template(template_path, output_prefix)
    doc_constructor.md_to_docx(f"{output_prefix}.docx")
