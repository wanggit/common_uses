#!/usr/bin/python
import mimetypes
import smtplib
from email import encoders
from email.mime.audio import MIMEAudio
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import argparse as ap

parser = ap.ArgumentParser()
parser.add_argument("-f", "--email_from", help="email from, default is wangg_mail@163.com", default="wangg_mail@163.com")
parser.add_argument("-t", "--to", help="to")
parser.add_argument("-u", "--user", help="username, default is wangg_mail@163.com", default="wangg_mail@163.com")
parser.add_argument("-p", "--pwd", help="password", default="Wanggang1")
parser.add_argument("-a", "--attach", help="attachment", default=None)
parser.add_argument("-s", "--subject", help="subject, default is No Subject", default="No Subject")
parser.add_argument("-m", "--message", help="Message, default is No Content", default="No Content")
parser.add_argument("--smtp", help="smtp server, default is smtp.163.com", default="smtp.163.com")
args = parser.parse_args()

emailfrom = args.email_from
emailto = args.to
fileToSend = args.attach
username = args.user
password = args.pwd

msg = MIMEMultipart()
msg["From"] = emailfrom
msg["To"] = emailto
msg["Subject"] = args.subject
content = MIMEText(args.message, 'plain', 'utf-8')
msg.attach(content)


if fileToSend is not None:
    ctype, encoding = mimetypes.guess_type(fileToSend)
    if ctype is None or encoding is not None:
        ctype = "application/octet-stream"

    maintype, subtype = ctype.split("/", 1)
    if maintype == "text":
        fp = open(fileToSend)
        # Note: we should handle calculating the charset
        attachment = MIMEText(fp.read(), _subtype=subtype)
        fp.close()
    elif maintype == "image":
        fp = open(fileToSend, "rb")
        attachment = MIMEImage(fp.read(), _subtype=subtype)
        fp.close()
    elif maintype == "audio":
        fp = open(fileToSend, "rb")
        attachment = MIMEAudio(fp.read(), _subtype=subtype)
        fp.close()
    else:
        fp = open(fileToSend, "rb")
        attachment = MIMEBase(maintype, subtype)
        attachment.set_payload(fp.read())
        fp.close()
        encoders.encode_base64(attachment)
    attachment.add_header("Content-Disposition", "attachment", filename=fileToSend)
    msg.attach(attachment)

server = smtplib.SMTP(args.smtp)
server.login(username,password)
server.sendmail(emailfrom, emailto, msg.as_string())
server.quit()
