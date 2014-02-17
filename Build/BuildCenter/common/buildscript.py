import os
import web
import time
import thread
from models import model
# import model

script = {
	'db':'/Users/buildserver/BuildFolder/Shell/db.sh',
	'ir':'/Users/buildserver/BuildFolder/Shell/ir.sh',
	'release':'/Users/buildserver/BuildFolder/Shell/release.sh',
}

class BuildScript(object):

	def db(self,buildid,buildnumber,outpath):
		status = self.execute(script['db'],[buildnumber,str(buildid)],outpath)
		self.update_status(buildid,status)

	def ir(self,buildid,branch, version,outpath):
		status = self.execute(script['ir'],[branch,version,str(buildid)],outpath)
		self.update_status(buildid,status)

	def release(self,buildid,version,outpath):
		status = self.execute(script['release'],[version],outpath)
		self.update_status(buildid,status)

	def update_status(self,buildid,status):
		if status==0:
			model.update_status_success(buildid)
		else:
			model.update_status_fail(buildid)

	def execute(self,script, parameters,outpath):
		command = script
		for parm in parameters:
			command+=' '+parm

		command+=' > '+outpath
		print command

		directory = os.path.dirname(outpath)
		os.system('mkdir '+directory)

		return os.system(command)
		
def build(type,params):
	script = 'db' if type==1 else ('ir' if type == 2 else 'release')
	method = getattr(BuildScript(),script)

	if type==1 or type==3:
		method(params[0],params[1],params[2])
	else:
		method(params[0],params[1],params[2],params[3])

def buildasync(type,params):
	script = 'db' if type==1 else ('ir' if type == 2 else 'release')
	method = getattr(BuildScript(),script)
	#method(params[0],params[1])
	thread.start_new_thread(method, params)


# if __name__ == '__main__':
# 	build(2,(124,'dev','v1.0.1.2','/Users/buildserver/BuildFolder/Archives/test.log'))