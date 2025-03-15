import os
from confluence_extractor.config import Config
import json
import pypandoc
import logging

class DocContent:
    def __init__(self, config: Config, doc_text="", input_format="md"): 
        """
        DocContent is a class that holds a document in generic form. Every manipulation
        (now only: adding stuff) first converts the input to pandoc internal format (json)
        """
        self.config = config
        self.json_content = ""
        if doc_text:
            self.json_content = self._input_to_json(doc_text, input_format)

    def _extend_blocks(self, pandoc_json):
        self.json_content['blocks'].extend(pandoc_json['blocks'])


    def add_doc_part(self,doc_text,input_format="md"):
        """
        convert the doc_text to pandoc json and add to the main document, 
        if this is the first time, also the meta-data are initialized.
        """
        json_content = self._input_to_json(doc_text, input_format)
        if self.json_content:
            self._extend_blocks(json_content)
        else:
            self.json_content = json_content

    def add_json_from_file(self,filename):
        """
        add the json in the file to the main document (append the block section)
        """
        with open(f"{filename}", "r") as f:
            pandoc_json = json.load(f)
        self._extend_blocks(pandoc_json)

    def _input_to_json(self,input_content,input_format):
        try:
            json_content = pypandoc.convert_text(input_content,format=input_format, to="json")
        except Exception as e:
            logging.error(f"_input_to_json: pandoc exception {e}")
        return json.loads(json_content)

    def format(self,output_format="md"):
        extra_args = []
        if output_format == "docx":
            arg = f'--reference-doc={self.config.docx_template}'
            extra_args.append(arg)
        

        # if you want to find out your pandoc version, uncomment this
        # produces the version with a WARNING
        #arg = f'--version'
        #extra_args.append(arg)
        
        #arg = f'--log=pandoc.log'
        #extra_args.append(arg)

        try:
            output = pypandoc.convert_text(self.json_content, 
                     format="json", to=output_format,
                     extra_args=extra_args)
        except Exception as e:
            logging.error(f"to_text: pandoc exception {e}")
        return output
    
    def format_to_file(self,output_file:str,output_format=""):
        """ 
        convert input file (file with.<input_type>) to output_type (e.g. docx) using pandoc. 
        default output format is the file extension so: foo.docx will be put to docx. if for a reason it is needed to write docx to .zip, use the second argument
        output file is md_filename with input_type replaced by output_type
        """
        file_extension = os.path.splitext(output_file)[1]
        if not output_format:
            output_format = file_extension[1:]
        json_file = output_file.replace(f"{file_extension}", ".json")
        self.to_json(json_file)

        extra_args = []
        if output_format == "docx":
            arg = f'--reference-doc={self.config.docx_template}'
            extra_args.append(arg)

        arg = f'--resource-path={self.config.resource_path}'
        extra_args.append(arg)
        
        # if you want to find out your pandoc version, uncomment this
        # produces the version with a WARNING
        #arg = f'--version'
        #extra_args.append(arg)
        
        #arg = f'--log=pandoc.log'
        #extra_args.append(arg)

        logging.info( f"convert json file to output_file={output_file}" )
        
        try:
            output = pypandoc.convert_file(json_file, to=output_format,
                                    outputfile=output_file,
                                    extra_args=extra_args)
            if output:
                logging.warning( f"Pandoc output: {output}")
        except Exception as e:
            logging.error(f"Pandoc error: {e}")

    def to_json(self, json_file):
        with open(json_file, "w") as f:
            json.dump(self.json_content,f)

    def to_docx(self, filename):
        self.format_to_file(filename, "docx")

if __name__ == "__main__":
    config = Config()
    docc = DocContent(config)
    print(docc.json_content)