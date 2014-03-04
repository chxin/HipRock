import os
import web
from models import model
from common import process

t_globals = {  
    'datestr': web.datestr,  
    'cookie': web.cookies, 
    'archive' : 'http://10.177.206.47:81/archive',
}
render = web.template.render('templates', base='master', globals=t_globals)

class Home:
	def GET(self):
		db=model.get_top_db(True)
		ir=model.get_latest_ir()
		release=model.get_latest_release()

		return render.index(release,ir,db)

class DailyBuild:
	def GET(self):
		latest = model.get_top_db(False)
		builds = model.get_top_dbs()

		return render.dailybuild(latest,builds)

class InternalRelease:
	def GET(self):
		result = model.get_ir_all()
		groups = model.group_versions(2)
		return render.internalrelease(result,groups,'')


class InternalReleaseVersion:
	def GET(self, version):
		result = model.get_ir_builds(version)
		groups = model.group_versions(2)
		return render.internalrelease(result,groups,version)


class Release:
	def GET(self):
		result = model.get_release_all()
		groups = model.group_versions(3)
		return render.release(result,groups,'')

class ReleaseVersion:
	def GET(self,version):
		result = model.get_release_builds(version)
		groups = model.group_versions(3)
		return render.release(result,groups,version)
		