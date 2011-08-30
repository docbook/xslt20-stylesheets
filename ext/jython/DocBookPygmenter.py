from org.docbook.extensions.xslt20.jython import PygmenterType;

from pygments import highlight
from pygments.lexers import (get_lexer_by_name, get_lexer_for_mimetype)
from pygments.lexers import guess_lexer
from pygments.formatters import (HtmlFormatter, get_formatter_by_name)

class DocBookPygmenter(PygmenterType):
   def __init__(self):
      self.formatname = "html"

   #def setFormatter(self,name):
   #   self.formatname = name

   def format(self, code, language):
      if language == "":
         lexer = guess_lexer(code)
      else:
         lexer = get_lexer_by_name(language)
      formatter = get_formatter_by_name(self.formatname)
      return highlight(code, lexer, formatter)
