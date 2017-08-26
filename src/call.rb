require 'rubygems'
require 'twilio-ruby'

account_sid = ENV["ACCOUNT_SID"]
auth_token  = ENV["AUTH_TOKEN"]

phonefrom = "0032000000"
phonedest = "0908885552"
timestamp = "_"

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new account_sid, auth_token
#
@call = @client.calls.create(
  :from => "#{ENV["CALL_FROM"]}",   # From your Twilio number
  :to =>   "#{ENV["CALL_TO"]}",     # To any number
# Fetch instructions from this URL when the call connects
  #:url => 'http://153.127.195.16/call.xml'
  #:url => 'http://153.127.195.16:4567/first-confirm?person_count=5&start_time=20'
  #:url => "http://153.127.195.16:4567/first-confirm-wav?phone=#{phone_number}&timestamp=#{timestamp}"
  :url => "http://153.127.195.16:4567/first-confirm-wav?phonefrom=#{phonefrom}&timestamp=#{timestamp}&phonedest=#{phonedest}"
)


