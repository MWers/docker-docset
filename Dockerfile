FROM docker-docs:master

RUN mkdocs build

# - Set up Environment
#     - Install Python Dependencies
#     - Upload Doc Generation Script
# - Check out Docker repo from Github
# - Switch to latest release tag
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
