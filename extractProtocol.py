#!/usr/bin/python
import sys

if len(sys.argv) < 3:
    print('invalid argument, you need to provide location of Swift file and protocol name')
    exit()

filepath = sys.argv[1]
protocolName = sys.argv[2]

print 'protocol ' + protocolName + ' {'
with open(filepath) as f:
    content = f.readlines()
    for line in content:
        if 'func' in line and 'private' not in line:
            print line.rsplit('{', 1)[0]
print '}'