import web,os,time
import datetime

db = web.database(dbn = 'sqlite', db = '/Users/buildserver/BuildFolder/WebSite/db/blues.sqlite')  
archivefolder='/Users/buildserver/BuildFolder/Archives/'


def migrate(type):
	suffix = 'InternalRelease' if type == 2 else 'Release'
	dir=archivefolder+suffix

	for folder in os.listdir(dir):
		if folder.startswith('v'):
			fullpath = os.path.join(dir,folder)

			version = folder
			buildtime = time.ctime(os.path.getmtime(fullpath))
			path = '/{0}/{1}/'.format(suffix,version)

			update(os.path.join(fullpath,'BluesPad.plist'))

			db.insert('Build', description='Old build '+version,version=version,path=path,type=type,tags=version,status=1,buildtime=buildtime)
	

def update(plist):
	template = plist+'.temp'
	os.rename(plist,template)

	in_file = open(template,'r')
	out_file = open(plist,'w')
	for line in in_file:
		line = line.replace('http://10.177.206.47/IR', 'http://10.177.206.47:81/archive/InternalRelease')
		line = line.replace('http://10.177.206.47/Release', 'http://10.177.206.47:81/archive/Release')
		out_file.write(line)

	out_file.close()
	in_file.close()

if __name__ == '__main__':
	migrate(2)
	migrate(3)
 