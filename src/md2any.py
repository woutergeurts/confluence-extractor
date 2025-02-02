import pypandoc
import os
import logging

DEFAULT_DOCX_TEMPLATE = "../examples/reference.docx"
class Md2Any:
    def __init__(self, docx_template="", md_dir=""):
        if docx_template:
            self.docx_template = docx_template
        else:
            self.docx_template = DEFAULT_DOCX_TEMPLATE

        self.md_dir = md_dir    

    def pandoc_convert_md_to(self, output_type:str, md_filename:str):
        """ 
        convert filename (.md file) to output_type using
        pandoc. output file is 

        """
        input_file = md_filename
        output_file = input_file.replace('md', output_type)
        if self.md_dir:
            md_dir = self.md_dir
        else:
            md_dir = os.path.dirname(md_filename)
            input_file = os.path.basename(md_filename)  
       
        old_working_dir = os.getcwd()
        os.chdir(md_dir)
        
        output_file = input_file.replace('md', output_type)

        extra_args = []
        if output_type == "docx":
            arg = f'--reference-doc={self.docx_template}'
            extra_args.append(arg)

        logging.info( f"convert input_file={input_file} to output_file={output_file} dir = {md_dir}" )
        
        try:
            output = pypandoc.convert_file(input_file, output_type, 
                                    outputfile=output_file,
                                    extra_args=extra_args)
            if output:
                logging.warning( f"Pandoc output: {output}")
        except Exception as e:
            logging.error(f"Pandoc error: {e}")
            raise

        os.chdir(old_working_dir)


    def md_to_docx(self,md_filename: str):
        """ convert md file to docx using pandoc
        """
        self.pandoc_convert_md_to("docx", md_filename)

# Example usage: see examples directory