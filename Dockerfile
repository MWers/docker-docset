FROM docker-docs:master

RUN apt-get update && apt-get install -y \
	python-lxml

COPY theme /docs/theme

RUN VERSION=$(cat VERSION) \
        && MAJOR_MINOR="${VERSION%.*}" \
        && for i in $(seq $MAJOR_MINOR -0.1 1.0); do \
                echo "<li><a class='version' href='/v$i'>Version v$i</a></li>"; \
        done > sources/versions.html_fragment \
        && GIT_BRANCH=$(cat GIT_BRANCH) \
        && GITCOMMIT=$(cat GITCOMMIT) \
        && AWS_S3_BUCKET=$(cat AWS_S3_BUCKET) \
        && BUILD_DATE=$(date) \
        && sed -i "s/\$VERSION/$VERSION/g" theme/mkdocs/base.html \
        && sed -i "s/\$MAJOR_MINOR/v$MAJOR_MINOR/g" theme/mkdocs/base.html \
        && sed -i "s/\$GITCOMMIT/$GITCOMMIT/g" theme/mkdocs/base.html \
        && sed -i "s/\$GIT_BRANCH/$GIT_BRANCH/g" theme/mkdocs/base.html \
        && sed -i "s/\$BUILD_DATE/$BUILD_DATE/g" theme/mkdocs/base.html \
        && sed -i "s/\$AWS_S3_BUCKET/$AWS_S3_BUCKET/g" theme/mkdocs/base.html

RUN mkdocs build

COPY abs2rel.py /docs/abs2rel.py

RUN python abs2rel.py -v /docs/site

RUN mkdir -p /docs/release


#      - Make docset directory hierarchy
#      - Move docs to proper location
#      - Convert absolute links to relative
#      - Generate SQLite DB
#      - Populate db with index
#      - Move icon files to proper location in docset
#      - tar and gzip docset
#      - Copy to S3/Github/???

# - Switch to latest release tag

