import os

def generateCommonHeaders():
	commonRoot = os.path.abspath('../Src/Common/')
	genFile = open(os.path.join(commonRoot,'REMCommonHeaders.h'), 'w')

	scanClasses(commonRoot, genFile)

	genFile.close()

def scanClasses(root,output):
	for file in os.listdir(root):
		fullname = os.path.join(root,file)
		if(os.path.isdir(fullname)):
			output.write('\n//'+file+'\n')
			scanClasses(fullname,output)
		else:
			if fullname != output.name and file.endswith('.h'):
				output.write('#import "'+file+'"\n')
				print file

if __name__ == '__main__':
	generateCommonHeaders()