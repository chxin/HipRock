import os
import sys


def update(plist,url,bundleversion):
	template = plist+'.temp'
	os.rename(plist,template)

	in_file = open(template,'r')
	out_file = open(plist,'w')
	for line in in_file:
	    out_file.write(line.replace('##rooturl##', url).replace('##bundleversion##',bundleversion))
	out_file.close()
	in_file.close()


if __name__ == '__main__':
	update(sys.argv[1],sys.argv[2],sys.argv[3])