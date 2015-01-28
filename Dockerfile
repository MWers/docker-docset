FROM docker-docs:master

COPY theme /docs/theme

RUN mkdocs build

# RUN pip install lxml

COPY mkdocs2dash.py /docs/mkdocs2dash.py

COPY abs2rel.py /docs/abs2rel.py

# COPY css/bootstrap-responsive.css /docs/site/css/bootstrap-responsive.css

RUN python abs2rel.py /docs/site

# - Switch to latest release tag

# - Convert youtube embeds to links

# - Run documentation generation script
#      - Replace parts of doc templates
#      - Generate html docs
#      - Make docset directory hierarchy
#      - Move docs to proper location
#      - Convert absolute links to relative
#      - Generate SQLite DB
#      - Populate db with index
#      - Move icon files to proper location in docset
#      - tar and gzip docset
#      - Copy to S3/Github/???
