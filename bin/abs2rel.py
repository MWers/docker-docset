#!/usr/bin/env python

import argparse
import os
import sys

import lxml.html

parser = argparse.ArgumentParser()
parser.add_argument('path',
                    help=('The path containing files with links to '
                          'convert from absolute to relative'))
parser.add_argument('--suffix',
                    dest='suffix',
                    default='.html',
                    help='the suffixes of the files to convert')
parser.add_argument('-v', '--verbose',
                    dest='verbose',
                    action='store_true')
parser.add_argument('-vv',
                    dest='vverbose',
                    action='store_true')
args = parser.parse_args()

if args.vverbose:
    args.verbose = True

if not os.path.isdir(args.path):
    print 'Error: Directory %s does not exist' % args.path
    sys.exit


def abs2rel(link):
    if link[:1] == '/' and link[:2] != '//':
        # Convert links to relative
        # ex. os.path.relpath('/foo', '/foo/bar/bav') => '../..'
        relpath = os.path.relpath(args.path, root)
        newlink = '%s%s' % (relpath, link)
    else:
        newlink = link

    if args.vverbose:
        print '(abs2rel) old link: %s' % link
        print '(abs2rel) new link: %s' % newlink
        print

    return newlink


if args.verbose:
    print 'Replacing absolute links with relative links'

for root, dirs, files in os.walk(args.path):
    for file in files:
        if file.find(args.suffix) != -1:
            page = open(os.path.join(root, file)).read()

            if args.verbose:
                print 'file: %s/%s' % (root, file)

            html = lxml.html.fromstring(page)
            html.rewrite_links(abs2rel)

            # Write the updated links back to the file
            with open(os.path.join(root, file), 'w') as f:
                f.write(lxml.html.tostring(html))
