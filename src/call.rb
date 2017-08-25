require 'rubygems'
#require 'sinatra'
require 'twilio-ruby'

account_sid = 'AC142f11981dca802f7f2e93032877ae74'
auth_token = '1f0bf38a4c344cd95718218e5e45afa0'

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new account_sid, auth_token
#
@call = @client.calls.create(
  :from => '+81345789902',   # From your Twilio number
  :to => '+819085353532',     # To any number
# Fetch instructions from this URL when the call connects
  #:url => 'http://153.127.195.16/call.xml'
  :url => 'http://153.127.195.16:4567/first-confirm?person_count=5&start_time=20'
)

#response = Twilio::TwiML::VoiceResponse.new
#response.dial(number: '+819085353532', callerId: "+81345789902")
#response.say('Goodbye')

