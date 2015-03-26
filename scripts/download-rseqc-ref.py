#!/usr/bin/env python

import os,sys
import xml.etree.ElementTree as ET

if len(sys.argv)!=2:
  print "USAGE: %s <download directory>"%sys.argv[0]
  sys.exit(1)

outdir=sys.argv[1]

t = ET.parse('rseqc-ref-files.xml')
for i in t.getroot().findall('.//item'):
  title = i.find('title').text
  link = i.find('link').text
  os.system("mkdir -p $(dirname %s/%s)"%(outdir,title))
  os.system("wget -O %s/%s %s"%(outdir,title,link))


