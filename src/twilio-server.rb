require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'logger'

get '/callback-answer' do
  logger.info("testaaa") 
  logger.info(params)
  logger.info("test") 
  PUSH_KEY = params["Digits"]
  response = Twilio::TwiML::VoiceResponse.new do |r|
    r.say("あなたの押したキーは #{PUSH_KEY} ですね", voice: 'woman', language: "ja-JP")
  end.to_s
  logger.info(response)
  response
end

get '/hello-monkey' do
  people = {
    '+14158675309' => 'Curious George',
    '+14158675310' => 'Boots',
    '+14158675311' => 'Virgil',
    '+14158675312' => 'Marcel',
  }
  name = people[params['From']] || 'Monkey'
  Twilio::TwiML::VoiceResponse.new do |r|
    r.say("Hello もとださん 二次会アプリケーション頑張って作りましょう", voice: 'woman', language: "ja-JP")
  end.to_s
end
