import os
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import datetime
import sys

server = '10.177.1.111'
port = 25
domain='@schneider-electric.com'

archive = 'http://10.177.206.47/archive'


def sendmail(sender,tos,ccs,logpath):
	# Create message container - the correct MIME type is multipart/alternative.
	msg            = MIMEMultipart('alternative')
	msg['Subject'] = 'Blues build failed.'
	msg['From']    = sender
	msg['To']      = ', '.join(tos)
	msg['Cc']      = ', '.join(ccs)

	# Create the body of the message (an HTML version).
	text = "Hey guys, build error! see build log: "+archive+logpath

	# Record the MIME types of both parts - text/plain and text/html.
	body = MIMEText(text, 'plain')

	# Attach parts into message container.
	msg.attach(body)

	# Send the message via local SMTP server.
	s = smtplib.SMTP(server, port)
	s.set_debuglevel(0)
	s.ehlo()
	s.sendmail(sender, tos+ccs, msg.as_string())
	s.quit()

def mailaddress(prefix):
	return '{0}{1}'.format(prefix,domain)

if __name__ == '__main__':
	sender=mailaddress('BluesBuildCenter')
	tos=[mailaddress('tan-tan.tan'),mailaddress('zilong-oscar.xu'),mailaddress('feng-aries.zhang')] #
	ccs=[mailaddress('jinhao.geng')]
	sendmail(sender,tos,ccs,sys.argv[1])