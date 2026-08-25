#!/usr/bin/env python3
"""Compare strain identifiers in two text/directory listings with light normalization."""
import re, sys
from pathlib import Path

def normalize(s):
    s=s.strip()
    # Windows DIR line -> final token
    if s and ('<DIR>' in s or re.match(r'\d\d/\d\d/\d{4}',s)):
        s=s.split()[-1]
    s=re.sub(r'(_genes_supertranscript.*|\.transdecoder\.pep|\.pep|\.fasta|\.fa|_GPDS)$','',s)
    s=s.replace('MZCH_561','MZCH561')
    # Normalize only the known historical M_ variants.
    s=re.sub(r'^M_(1384|2158|2213|2661)$',r'M\1',s)
    return s

def load(path):
    return {normalize(x) for x in Path(path).read_text().splitlines() if normalize(x)}

if len(sys.argv)!=3:
    raise SystemExit(f'usage: {sys.argv[0]} REFERENCE.txt OBSERVED.txt')
ref,obs=map(load,sys.argv[1:])
print('Missing from observed:')
for x in sorted(ref-obs): print(x)
print('\nExtra in observed:')
for x in sorted(obs-ref): print(x)
