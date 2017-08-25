require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'logger'

SERVER_URL = "http://153.127.195.16:4567"

post '/first-confirm' do
  PERSON_COUNT = params["person_count"]
  START_TIME = params["start_time"]
  response = Twilio::TwiML::VoiceResponse.new do |r|
    r.say("すみません。予約をお願いしたいのですが、#{START_TIME} 時から #{PERSON_COUNT} 人で空いていますか？", voice: 'woman', language: "ja-JP")
    r.gather(action: "#{SERVER_URL}/shop_answer", method: 'GET') do |gather|
      gather.say("予約可能であれば １を、できなければ３を押してください", voice: 'woman', language: "ja-JP")
    end
  end.to_s
  logger.info(response)
  response
end

get '/shop_answer' do
  logger.info("shop_answer")
  logger.info(params)
  ANSWER_DIGITS = params["Digits"]
  logger.info(ANSWER_DIGITS)
  response = Twilio::TwiML::VoiceResponse.new do |r|
    if ANSWER_DIGITS == "1"
      r.say("予約させていただきました", voice: 'woman', language: "ja-JP")
    else
      r.say("予約できないとのことで、了解いたしました。", voice: 'woman', language: "ja-JP")
    end
  end.to_s
end

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
  Twilio::TwiML::VoiceResponse.new do |r|
    r.say("Hello もとださん 二次会アプリケーション頑張って作りましょう", voice: 'woman', language: "ja-JP")
  end.to_s
end
