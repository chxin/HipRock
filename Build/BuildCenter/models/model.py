import web  
import datetime

db = web.database(dbn = 'sqlite', db = 'db/blues.sqlite')  

#db=1, ir=2, release=3

def get_top_db(issucc):
	condition = 'type=1 and status=1' if issucc else 'type=1'
	builds = db.select('Build', where=condition, order='id desc', limit=10)
	return builds[0]

def get_top_dbs():
	builds = db.select('Build', where='type=1', order='id desc', limit=10, offset=1)
	return builds

def  get_latest_ir():
	builds = db.select('Build', where='type=2 and status=1', order='id desc', limit=1)
	return builds[0]

def get_ir_all():
	return db.select('Build', where='type=2', order='id desc')

def get_ir(id):
	return db.select('Build', where='id='+str(id), order='id desc')

def get_ir_for_release():
	return db.query('SELECT * FROM Build where version not in (select version from Build where type=3) and type=2')

def get_ir_builds(version):
	return db.select('Build', where="version like '"+version+"%' and type=2", order='id desc')

def get_ir_build_version(version):
	return db.select('Build', where="version ='"+version+"' and type=2")



def  get_latest_release():
	builds = db.select('Build', where='type=3 and status=1', order='id desc', limit=1)
	return builds[0]

def get_release_all():
	return db.select('Build', where='type=3', order='id desc')

def get_release_builds(version):
	return db.select('Build', where="version like '"+version+"%' and type=3", order='id desc')

def get_release_version_groups():
	releases = get_release_all()
	groups=[]
	for release in releases:
		print release.version



def create_build(build):
	return db.insert('Build', description=build['description'],version=build['version'],path=build['path'],type=build['type'],tags=build['tags'],branch=build['branch'],appname=build['appname'])
 
def update_status_success(id):
	return db.update('Build', where='id='+str(id), status='1')
def update_status_fail(id):
	return db.update('Build', where='id='+str(id), status='-1')

def group_versions(type):
	groups=[]
	records = get_ir_all() if type==2 else get_release_all()

	for ir in records:
		if '.' in ir.version:
			segements = ir.version.split('.')
			mainversion = '{0}.{1}'.format(segements[0],segements[1])
			if not mainversion in groups:
				groups.append(mainversion)

	return groups
	
if __name__ == '__main__':
	get_release_version_groups()