import sys, os 
import web
from controllers import homecontroller
from controllers import managecontroller

#define urls
urls = (
	'/*', homecontroller.Home,
	'/db/*', homecontroller.DailyBuild,
	'/ir/(.+)', homecontroller.InternalReleaseVersion,
	'/ir/*', homecontroller.InternalRelease,
	'/release/(.+)', homecontroller.ReleaseVersion,
	'/release/*', homecontroller.Release,

	'/manage/*', managecontroller.DailyBuild,
	'/manage/db', managecontroller.DailyBuild,
	'/manage/ir', managecontroller.InternalRelease,
	'/manage/release', managecontroller.Release,
)

#define app
app = web.application(urls,globals())

def notfound():  
    return web.notfound("Sorry, the page you were looking for was not found.")  
      
app.notfound = notfound  

#session = web.session.Session(app, web.session.DiskStore(os.path.join(abspath,'sessions')),)

#application = app.wsgifunc()

#define classes
#class hello:
#	def GET(self):
#		return 'hello world'



if __name__ == '__main__':
	app.run()

