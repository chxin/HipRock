import os

mark = '#pragma mark - Definitions'

def generateCommonHeaders():
	root = os.path.abspath('../Src/BluesPad/Resource/Images')
	filename = os.path.abspath('../Src/BluesPad/Resource/Definitions/REMImages.h')

	headers = fileheader(filename)
	#print headers
	
	outputfile = open(filename, 'w')
	outputfile.writelines(headers)
	outputfile.writelines(mark+'\n')
	scanimages(root,outputfile)
	outputfile.writelines('\n#endif')

	outputfile.close()
	

def fileheader(filename):
	file = open(filename, 'r')

	headers = ''
	line = file.readline()
	while not line.startswith(mark):
		headers+=line
		line = file.readline()

	file.close()

	return headers


def scanimages(root,output):
	entries = os.listdir(root)
	files = [file for file in entries if os.path.isfile(os.path.join(root,file))]
	folders = [os.path.join(root,folder) for folder in entries if os.path.isdir(os.path.join(root,folder))]

	rootname = '/' if root.split('Images')[1]=='' else root.split('Images')[1]

	#print '\nfiles in '+rootname+':'
	output.writelines('\n//images in '+rootname+':\n')
	for file in files:
		if (file.endswith('.png') or file.endswith('.jpg')) and ('@2x' not in file):
			pointindex = file.rfind('.')
			imagename = file[0:pointindex]
			#imagetype = file[pointindex+1:]
			definition = '#define REMIMG_'+parseimagename(imagename)+' REMLoadImageNamed(@"'+imagename+'")'

			#print file
			#print definition
			output.writelines(definition+'\n')
	for folder in folders:
		scanimages(folder, output)

def parseimagename(origin):
	origin = origin.replace('-','_')
	origin = origin.replace('.','_')
	return origin


if __name__ == '__main__':
	generateCommonHeaders()