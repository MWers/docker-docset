FROM docker-docs:master

RUN apt-get update && apt-get install -y \
	python-lxml \
	python-yaml

COPY assets/theme /docs/theme

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

RUN find /docs/site -type f -name "*.md~" -exec rm -f {} \;

COPY abs2rel.py /docs/abs2rel.py
RUN python abs2rel.py -v /docs/site

RUN mkdir -p /docs/release/Docker.docset/Contents/Resources/Documents

RUN cp -a /docs/site/* /docs/release/Docker.docset/Contents/Resources/Documents

# TODO: Add index for select pages (like Dockerfile and CLI reference)
COPY yaml2sqlite.py /docs/yaml2sqlite.py
RUN python yaml2sqlite.py -v mkdocs.yml /docs/release/Docker.docset/Contents/Resources/docSet.dsidx

COPY assets/docset/icon@2x.png /docs/release/Docker.docset/icon@2x.png
COPY assets/docset/icon.png /docs/release/Docker.docset/icon.png
COPY assets/docset/Info.plist /docs/release/Docker.docset/Contents/Info.plist

WORKDIR /docs/release
RUN tar --exclude='.DS_Store' -cvzf Docker.tgz Docker.docset

#      - Copy to S3/Github/???

# - Switch to latest release tag

