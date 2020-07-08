#!/usr/local/bin/python3
import sys
import subprocess

COLOR_NORM = '\x1B[0m' # normal color
COLOR_ERR  = '\x1B[1;31m' # bold red
COLOR_NOMSGS= '\x1B[1;32m' # bold green

COLOR_SUBJ = COLOR_NORM
COLOR_DATE = '\x1B[1;34m' # bold blue
COLOR_TIME = '\x1B[1;32m' # bold green
COLOR_FROM = '\x1B[0;33m' # yellow

STR_ERR = COLOR_ERR + 'ERROR: ' + COLOR_NORM

MSG_FIELDS = [ 'date', 'time', 'subj', 'from' ]

SCPT_MAIL = '''
tell application "Mail"
check for new mail

set unreadMsgs to (messages of inbox whose read status is false)

if number of items in unreadMsgs is greater than 0 then
    repeat with i from 1 to number of items in unreadMsgs
        set msg to item i of unreadMsgs
		set msgDate to msg's date received
		set msgSubj to msg's subject
		set strSender to msg's sender as string

		set strDate to short date string of msgDate
		set strTime to time string of msgDate
		if length of msgSubj is less than 96 then
			set strSubj to msgSubj
		else
			set strSubj to text 1 thru 96 of msgSubj
		end if

		log "bgn\n" & "date\n" & strDate & "\ntime\n" & strTime & "\nsubj\n" & strSubj & "\nfrom\n" & strSender & "\nend"
    end repeat
end if
end tell
'''

def report_err(fmt, *args):
	msg = fmt % args

	sys.stderr.write("{}{}\n".format(STR_ERR, msg))

def get_new_mail():
	#try:
		cmd = ['osascript', '-']
		with subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT) as proc:
			proc.stdin.write(bytes(SCPT_MAIL.encode('ascii')))
			proc.stdin.close()
			result = proc.stdout.read()

		#output = p.communicate(input='some data'.encode())[0]
		#result = subprocess.check_output(['osascript', 'check_new_mail.scpt'], stderr= subprocess.STDOUT)
		return result.decode('utf8').split('\n')
	#except:
		report_err('failed to get new mail')
		return []

def parse_mail_command_list(cmd_list):
	msgs = []
	msg = None
	curr_cmd = None
	for line in cmd_list:

		if line == 'bgn':
			msg = {}
			for field in MSG_FIELDS:
				msg[field] = ''
		elif line == 'end':
			msgs.append(msg)
			msg = None
			curr_cmd = None
		elif line in MSG_FIELDS:
			curr_cmd = line
		elif curr_cmd and msg:
			msg[curr_cmd] += line

	return msgs

def report_mail(msgs):
	if not msgs:
		print('* {}NO UNREAD EMAILS{}'.format(COLOR_NOMSGS, COLOR_NORM))
		return

	for msg in msgs:
		print('* {}{} {}{} {}\'{}\' - {}{}{}'.format(
			COLOR_DATE, msg['date'],
			COLOR_TIME, msg['time'],
			COLOR_SUBJ, msg['subj'],
			COLOR_FROM, msg['from'],
			COLOR_NORM))

msgs = parse_mail_command_list(get_new_mail())
report_mail(msgs)
