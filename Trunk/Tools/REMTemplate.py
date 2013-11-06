import os
import shutil

header = '//\n//  ___FILENAME___\n//  ___PROJECTNAME___\n//\n//  Created by ___FULLUSERNAME___ on ___DATE___.\n//___COPYRIGHT___\n//\n'
copyright = '/*------------------------------Summary-------------------------------------\n * Product Name : EMOP iOS Application Software\n * File Name	: ___FILENAME___\n * Date Created : ___FULLUSERNAME___ on ___DATE___.\n * Description  : IOS Application software based on Energy Management Open Platform\n * Copyright    : Schneider Electric (China) Co., Ltd.\n--------------------------------------------------------------------------*/'


def main():
	xcodetemplate = '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/File Templates/Cocoa Touch'
	usertemplateroot = '~/Library/Developer/Xcode/Templates/File Templates'
	usertemplatename = 'REM Cocoa Touch'

	usertemplateroot = usertemplateroot.replace('~',os.path.expanduser('~'))
	usertemplate = os.path.join(usertemplateroot, usertemplatename)

	if not os.path.exists(usertemplateroot):
		os.makedirs(usertemplateroot)
		shutil.copytree(xcodetemplate, usertemplate)

	#replace all header in .h of .m files
	search(usertemplate)
	

def search(folder):
	files = [f for f in os.listdir(folder) if os.path.isfile(os.path.join(folder,f)) and (f.endswith('.h') or f.endswith('.m'))]
	dirs = [f for f in os.listdir(folder) if os.path.isdir(os.path.join(folder,f))]

	for file in files:
		replace(os.path.join(folder,file))
	for dir in dirs:
		search(os.path.join(folder,dir))

def replace(file):
	print file
	fileread = open(file,'r')
	content = ''.join(fileread.readlines())
	#print content
	newcontent = content.replace(header,copyright)
	print newcontent
	print ''
	fileread.close()

	filewrite = open(file,'w')
	filewrite.write(newcontent)
	filewrite.close()


if __name__ == '__main__':
	main()
