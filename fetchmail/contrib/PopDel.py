# PopDel.py  Copyright Richard Harris 2002
#
# author: Richard Harris (rover@emptydog.com)
# The author releases this file under the GPL
# license. See COPYING for specifics.
#
# See PopDel.manual for the use of this Python class.
#
# created: 01 May 02
# change log:
# Hacked to support message ranges by ESR, January 2003.
#
import os, poplib, string, sys

class PopDel:
	HDR = "\nPopDel - Delete messages from popmail - Ver. 0.1"
	BYE = "\n  PopDel Ver.0.1 by Richard Harris\n" +\
		  "     site - http://emptydog.com\n" +\
		  "     email - rover@emptydog.com\n"
	PROMPT1 = "Choose message number to delete or 'q' to quit: "
	PROMPT2 = "Quit or abort: "
	CHOICES = ["Save changes and quit.",
			   "Abort and make no deletions."]
	
	def __init__(self):
		self.done = 0
		return

	# get user to choose an element from thing
	def query(self, thing, prompt):
		length = len(thing)
		choice = [length]
		for i in range(0, length):
			print '(' + `i +  1` + ') ' + thing[i]
		while filter(lambda x: x > length, choice):
			choice = raw_input(prompt)
			if (choice == 'q'):
				self.done = 1
				choice = [-1]
			else:
				choice = map(int, string.split(choice, "-"))
				if len(choice) > 1:
					choice = range(choice[0], choice[1]+1)
		return choice

	def run(self):
		#log in
		os.system('clear')
		print self.HDR

		subjects = []

		M = poplib.POP3(sys.argv[1])
		M.user(sys.argv[2])
		M.pass_(sys.argv[3])
		M.set_debuglevel(1)

		messages = M.list()

		list = messages[1]
		if (len(list) == 0):
			M.quit()
			print '\nNo messages on server.'
		else:
			for entry in list:
				tokens = string.split(entry)
				head = M.top(int(tokens[0]), 32)
				for line in head[1]:
					if (string.find(line, 'Subject:') == 0):
						subject = string.replace(line, 'Subject:','')
						subject = subject + ' - ' + tokens[1] + ' octets'
						subjects.append(subject)
						break

			while not self.done:
				os.system('clear')
				print self.HDR
				print '\nMessages on server:'
				msglist = self.query(subjects, self.PROMPT1)
				print "Choice:", msglist
				for msg in msglist:
					if (msg > -1):
						M.dele(msg+1)
						subjects[msg] = subjects[msg] + ' -X-'

			print '\nExit Options:'
			choice = self.query(self.CHOICES, self.PROMPT2)
			print "Choice:", choice
			if (choice == [1]):			# commit changes and quit
				M.quit()
			else:						# reset and quit
				M.rset()
				M.quit()


		print self.BYE
		return


#-----------------main
obj = PopDel()
obj.run()