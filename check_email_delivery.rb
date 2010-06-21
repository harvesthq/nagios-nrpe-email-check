#!/usr/bin/env ruby
# ===========================================================================
# Test if this server can successfully send email or not
# ===========================================================================
# 1: Send an email with identifiable subject to a test mailbox
# 2: Wait 
# 3: Look for message in destination mailbox (IMAP)
# 4: Alert if not found
# ===========================================================================

require 'net/imap'
require "socket"

# ===============
# Helpers
# ===============
def tellme(message)
     puts "#{message}"
end

# ===============
# Settings
# ===============
hostname  = Socket.gethostname
mailx     = '/usr/bin/mailx'
wait_time = 6 #how many seconds to wait before we go looking for our message

t = Time.now
timestr = t.strftime("%m_%d_%Y-%I_%M%p")
subject_sought = "#{timestr}-#{hostname}" #we will be looking for this subject
tellme "Email: #{subject_sought}"

# ===============
# Nagios exit codes
# ===============
EXIT_OK = 0
EXIT_WARNING = 1
EXIT_CRITICAL = 2
EXIT_UNKNOWN = 3

# ===============
# IMAP Settings
# ===============
imap_email  = 'yourloginhere@gmail.com'
imap_host   = 'imap.gmail.com'
imap_port   = 993
imap_ssl    = true
imap_user   = 'yourloginhere'
imap_pass   = 'yourpasshere'
imap_folder = 'INBOX'

# ===============
# Send our test email
# ===============
tellme 'Sending...'
system(" echo 'Test' | #{mailx} -s #{subject_sought} #{imap_email} ")

# ===============
# Back off
# ===============
tellme 'Sleeping...'
sleep wait_time

# ===============
# Hunt!
# ===============
tellme 'Connecting...'
mailbox = Net::IMAP.new(imap_host, imap_port, imap_ssl)

tellme 'Logging in...'
mailbox.login(imap_user, imap_pass)

tellme "Selecting #{imap_folder}"
mailbox.select(imap_folder)

sought_messages = mailbox.search(["SUBJECT", "#{subject_sought}"])
found_messages = sought_messages.count

tellme 'Closing...'
mailbox.close

if found_messages >= 1
  tellme "OK: #{found_messages} emails found" 
  exit(EXIT_OK)
else
  tellme "ERROR: #{found_messages} emails found"
  exit(EXIT_CRITICAL)
end