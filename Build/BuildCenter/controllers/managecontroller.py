import os
import web
import time
import thread
from models import model
from common import buildscript

t_globals = {  
    'datestr': web.datestr,  
    'cookie': web.cookies,  
}
render = web.template.render('templates', base='master', globals=t_globals)
archivefolder='/Users/buildserver/BuildFolder/Archives/'


class DailyBuild:
	def GET(self):
		return render.make_dailybuild()
	def POST(self):
		parameters = web.input(_method='post')

		buildnumber='db-'+time.strftime("%Y%m%d%H%M%S", time.localtime())

		build = {}
		build['description'] = parameters['description'].replace('\n','<br/>')
		build['version'] = buildnumber
		build['path'] = '/DailyBuild/{0}/'.format(buildnumber)#dbpath
		build['type'] = 1
		build['tags'] = buildnumber
		build['branch'] = 'dev'

		buildid = model.create_build(build)

		buildlog=archivefolder+build['path']+'build.log'
		buildscript.buildasync(build['type'],(buildid, buildnumber,buildlog))

		return render.makesuccess(build, buildid)


class InternalRelease:
	def GET(self):
		return render.make_internalrelease()
	def POST(self):
		parameters = web.input(_method='post')

		build = {}
		build['description'] = parameters['description'].replace('\n','<br/>')
		build['version'] = parameters['version']
		build['path'] = '/InternalRelease/{0}/'.format(build['version'])
		build['type'] = 2
		build['tags'] = parameters['version']
		build['branch'] = parameters['branch']

		if len(model.get_ir_build_version(parameters['version']).list()) > 0:
			return render.makeerror('Version '+parameters['version']+' already exists!')

		buildid = model.create_build(build)

		buildlog=archivefolder+build['path']+'build.log'
		buildscript.buildasync(build['type'],(buildid, build['branch'],build['version'],buildlog))

		return render.makesuccess(build, buildid)

class Release:
	def GET(self):
		irs=model.get_ir_for_release()
		return render.make_release(irs)
	def POST(self):
		parameters = web.input(_method='post')

		#return parameters

		ir=model.get_ir(int(parameters['id']))[0]

		#return ir[0]

		build = {}
		build['description'] = parameters['description'].replace('\n','<br/>') if parameters['description'] else ir.description
		build['version'] = ir.version
		build['path'] = '/Release/{0}/'.format(ir.version)
		build['type'] = 3
		build['tags'] = ir.version
		build['branch'] = ir.branch

		buildid = model.create_build(build)

		buildlog=archivefolder+build['path']+'build.log'
		buildscript.buildasync(build['type'],(buildid, build['version'],buildlog))

		return render.makesuccess(build, buildid)
  
		
		

		
