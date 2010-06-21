### check_email_delivery.rb


### Description

This is a small, very simple Nagios NRPE plugin which attempts to make sure the server it runs on can send out email. 
When this plugin executes it sends out an email, waits a few seconds then goes looking for that email in a remote mailbox, alerting if the email is not found.

### Requirements

Ruby

Nagios (Tested with Nagios3 on Debian Lenny)

NRPE

Currently: mailx to send out emails (easily replaced)

A remote mailbox on an IMAP compatible server (easily replaced)

### License

Released under the MIT License

### Credits

Written by [Warwick Poole](http://warwickp.com) (wpoole@gmail.com)

Copyright by and funded by [Harvest](http://www.getharvest.com)

Nagios by Ethan Galstad