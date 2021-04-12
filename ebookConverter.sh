#!/usr/bin/env python3

# Author: Steven Gutzwiller

import getopt
import os
import subprocess
import sys

def exec_(cmd):
  print(' '.join(cmd))
  p = subprocess.Popen(cmd)
  rc = p.wait() % 255
  if rc != 0:
    print('Error: %s' % rc)
    sys.exit(rc)

def main(argv):
  try:
    params = [
      'help',
      'site=',
      'file=',
    ]
    opts, args = getopt.getopt(argv, '', params)
  except getopt.GetoptErr as err:
    print(str(err))
    print('')
    sys.exit(2)
  site = None
  file = None
  epubLoc = None
  print('%s' % opts)
  for o, a in opts:
    if o in ['--help']:
      print('./ebookConverter [OPTION] DEST')
      print('--help: prints proper usage')
      print('--site=URL: the url of the site to be converted to .epub format')
      print('--file=SOURCE: the file location of a file to be converted to .epub format')
    elif o in ['--site']:
      site = a
    elif o in ['--file']:
      file = None
    else:
      print('Unhandled option: %s' % o)
      sys.exit(2)
  if site and file:
    print('Invalid usage: Cannot use both --site and --file')
    sys.exit(2)
  if site:
    file = './tmp.html'
    exec_(['curl', '-L', '-o',  file, site])
  exec_(['ebook-convert', file, 'output.epub'])
  if site:
    exec_(['rm', '-f', file])

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))
