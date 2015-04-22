FROM mwers/docker-docs:1.6.0

MAINTAINER Matt Walker "walkerm@gmail.com"

RUN apt-get update && apt-get install -y \
	python-lxml \
	python-yaml

COPY assets/theme /docs/theme

RUN VERSION=$(cat VERSION) \
        && MAJOR_MINOR="${VERSION%.*}" \
        && for i in $(seq $MAJOR_MINOR -0.1 1.0); do \
                echo "<li><a class='version' href='/v$i'>Version $i</a></li>"; \
        done > sources/versions.html_fragment \
        && sed -i "s/\$VERSION/$VERSION/g" theme/mkdocs/base.html \
        && sed -i "s/\$MAJOR_MINOR/v$MAJOR_MINOR/g" theme/mkdocs/base.html

# FIXME: Update `abs2rel.py` to operate on a single file, similar to `add-dash-anchors.py`
COPY bin/abs2rel.py /docs/abs2rel.py
COPY bin/add-dash-anchors.py /docs/add-dash-anchors.py
COPY bin/yaml2sqlite.py /docs/yaml2sqlite.py

RUN mkdocs build \
		&& find /docs/site -type f -name "*.md~" -exec rm -f {} \; \
		&& find /docs/site -type f -name "*.md.old" -exec rm -f {} \; \
		&& rm -f /docs/site/search_content.json \
		&& python abs2rel.py -v /docs/site \
		&& find /docs/site -name "*.html" -exec /docs/add-dash-anchors.py {} -v \; \
		&& mkdir -p /docs/release/Docker.docset/Contents/Resources/Documents \
		&& cp -a /docs/site/* /docs/release/Docker.docset/Contents/Resources/Documents \
		&& python yaml2sqlite.py -v mkdocs.yml /docs/release/Docker.docset/Contents/Resources/docSet.dsidx

COPY assets/docset/icon@2x.png /docs/release/Docker.docset/icon@2x.png
COPY assets/docset/icon.png /docs/release/Docker.docset/icon.png
COPY assets/docset/Info.plist /docs/release/Docker.docset/Contents/Info.plist

WORKDIR /docs/release
RUN tar --exclude='.DS_Store' -cvzf Docker.tgz Docker.docset

