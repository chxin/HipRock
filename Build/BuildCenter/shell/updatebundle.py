import os
import xml.etree.ElementTree as ET
import sys

#plist = 'BluesPad-Info.plist'

def main(filename,bundleversion):
	tree = ET.parse(filename)
	root = tree.getroot()[0]

	bundleversionkeyindex=0
	for element in root.getchildren():
		if element.text == 'CFBundleVersion':
			break
		bundleversionkeyindex+=1

	print bundleversionkeyindex

	bundleversionvalueindex=bundleversionkeyindex+1

	valueelement = root.getchildren()[bundleversionvalueindex]
	valueelement.text = str(bundleversion)
	for element in valueelement:
		if element.tag == 'string':
			element.text = str(bundleversion)

	tree.write(filename)
	


if __name__ == '__main__':
	filename=sys.argv[1]
	bundleversion = sys.argv[2]
	main(filename,bundleversion)