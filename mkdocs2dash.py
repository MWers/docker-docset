#!/usr/bin/env python

import argparse
import os
import os.path
# from os.path import join, getsize

import lxml.html

# FIXME: Read this from input
# base = ('/tmpdir/Docker.docset/Contents/Resources/Documents')
base = ('/Users/matt/Dropbox/Projects/GitHub/docker/tmpdir/Docker.docset'
        '/Contents/Resources/Documents')


def abs2rel(link):
    if link[:1] == '/' and link[:2] != '//':
        # Convert links to relative
        # ex. os.path.relpath('/foo', '/foo/bar/bav') => '../..'
        path = os.path.relpath(base, root)
        newlink = '%s%s' % (path, link)
    else:
        newlink = link

    print '(abs2rel) old link: %s' % link
    print '(abs2rel) new link: %s' % newlink
    print

    return newlink


for root, dirs, files in os.walk(base):
    for file in files:
        if file.find('.html') != -1:
            page = open(os.path.join(root, file)).read()
            print
            # print "base: %s" % (base)
            # print "root: %s" % (root)
            print "file: %s/%s" % (root, file)
            html = lxml.html.fromstring(page)
            html.rewrite_links(abs2rel)

            # Write the updated links back to the file
            with open(os.path.join(root, file), 'w') as f:
                f.write(lxml.html.tostring(html))
            # print lxml.html.tostring(html)

            # TODO: Write file

# Generate sqlite3 database and index
