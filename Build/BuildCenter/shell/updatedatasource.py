import xml.etree.ElementTree as ET
import sys

#datasource='production'
#filename='Configuration.plist'

def update(filename,datasource):
	tree = ET.parse(filename)
	root = tree.getroot()[0]

	currentdatasourcekeyindex=0
	for element in root.getchildren():
		if element.text == 'CurrentDataSource':
			break
		currentdatasourcekeyindex+=1

	print currentdatasourcekeyindex

	currentdatasourcevalueindex=currentdatasourcekeyindex+1

	valueelement = root.getchildren()[currentdatasourcevalueindex]
	for element in valueelement:
		if element.tag == 'string':
			print '{0}-->{1}'.format(element.text,datasource)
			element.text = datasource

	tree.write(filename)

if __name__ == '__main__':
	filename=sys.argv[1]
	datasource = sys.argv[2]
	update(filename,datasource)