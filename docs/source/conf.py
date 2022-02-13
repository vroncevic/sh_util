# -*- coding: utf-8 -*-

project = u'sh_util'
copyright = u'2015, Vladimir Roncevic <elektron.ronca@gmail.com>'
author = u'Vladimir Roncevic <elektron.ronca@gmail.com>'
version = u'1.0'
release = u'https://github.com/vroncevic/sh_util/releases'
extensions = []
templates_path = ['_templates']
source_suffix = '.rst'
master_doc = 'index'
language = None
exclude_patterns = []
pygments_style = None
html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']
htmlhelp_basename = 'sh_utildoc'
latex_elements = {}
latex_documents = [(
    master_doc, 'sh_util.tex', u'sh\\_util Documentation',
    u'Vladimir Roncevic \\textless{}elektron.ronca@gmail.com\\textgreater{}',
    'manual'
)]
man_pages = [(master_doc, 'sh_util', u'sh_util Documentation', [author], 1)]
texinfo_documents = [(
    master_doc, 'sh_util', u'sh_util Documentation', author, 'sh_util',
    'One line description of project.', 'Miscellaneous'
)]
epub_title = project
epub_exclude_files = ['search.html']
