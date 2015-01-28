#!/usr/bin/env python

import argparse
import os
import os.path
import sys
# from os.path import join, getsize

# import lxml.html
parser = argparse.ArgumentParser()
parser.add_argument('path',
                    help=('The path containing files with links to '
                          'convert from absolute to relative'))
parser.add_argument('--suffix', dest='suffix', default='.html',
                   help='the suffix of the files to convert')
args = parser.parse_args()

# FIXME: Check to be sure that `args.path` exists

def abs2rel(link):
    if link[:1] == '/' and link[:2] != '//':
        # Convert links to relative
        # ex. os.path.relpath('/foo', '/foo/bar/bav') => '../..'
        path = os.path.relpath(args.path, root)
        newlink = '%s%s' % (args.path, link)
    else:
        newlink = link

    print '(abs2rel) old link: %s' % link
    print '(abs2rel) new link: %s' % newlink
    print

    return newlink


for root, dirs, files in os.walk(args.path):
    for file in files:
        if file.find('.html') != -1:
            page = open(os.path.join(root, file)).read()
            print
            # print "path: %s" % (args.path)
            # print "root: %s" % (root)
            print "file: %s/%s" % (root, file)
            # html = lxml.html.fromstring(page)
            # html.rewrite_links(abs2rel)

            # Write the updated links back to the file
            with open(os.path.join(root, file), 'w') as f:
                f.write(page)
                # f.write(lxml.html.tostring(html))
            # print lxml.html.tostring(html)

            # TODO: Write file

# Generate sqlite3 datapath and index
