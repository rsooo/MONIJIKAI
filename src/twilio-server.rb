require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'logger'

SERVER_URL = "http://153.127.195.16:4567"
WAV_SERVER_DIR = "http://153.127.195.16/wav"
RESULT_FILE_DIR = "/var/www/html/result"

def write_result_file(filename, content)
  File.open("#{RESULT_FILE_DIR}/#{filename}", "w") do |f|
    f.puts(content)
  end
end

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

post '/first-confirm-wav' do
  PHONEFROM = params["phonefrom"]
  PHONEDEST = params["phonedest"]
  TIMESTAMP = params["timestamp"]
  #PERSON_COUNT = params["person_count"]
  #START_TIME = params["start_time"]
  response = Twilio::TwiML::VoiceResponse.new do |r|
    2.times{ |i|
      r.play(loop: 1, url: "#{WAV_SERVER_DIR}/#{PHONEFROM}_#{i}.wav")
    }
    r.gather(action: "#{SERVER_URL}/shop_answer_wav?phonefrom=#{PHONEFROM}&timestamp=#{TIMESTAMP}&phonedest=#{PHONEDEST}", method: 'GET') do |gather|
      gather.play(loop: 1, url: "#{WAV_SERVER_DIR}/#{PHONEFROM}_2.wav")
    end
    
  end.to_s
  logger.info(response)
  response
end

get '/shop_answer_wav' do
  logger.info(params)
  PHONEFROM = params["phonefrom"]
  PHONEDEST = params["phonedest"]
  ANSWER_DIGITS = params["Digits"]
  TIMESTAMP = params["timestamp"]
  write_file_name = "#{PHONEFROM}_#{PHONEDEST}_#{TIMESTAMP}.result"
  response = Twilio::TwiML::VoiceResponse.new do |r|
    if ANSWER_DIGITS == "1"
      r.play(loop: 1, url: "#{WAV_SERVER_DIR}/#{PHONEFROM}_3.wav")
      r.play(loop: 1, url: "#{WAV_SERVER_DIR}/#{PHONEFROM}_4.wav")
      write_result_file(write_file_name, "OK")
    elsif ANSWER_DIGITS == "0"
      #r.say("もう一度再生", voice: 'woman', language: "ja-JP")
      r.redirect("#{SERVER_URL}/first-confirm-wav?phonefrom=#{PHONEFROM}&phonedest=#{PHONEDEST}&timestamp=#{TIMESTAMP}", method: 'POST')
    else
      r.say("予約できないとのことで、了解いたしました。", voice: 'woman', language: "ja-JP")
      write_result_file(write_file_name, "NG")
    end
  end.to_s
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
