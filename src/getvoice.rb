require 'net/http'
require 'json'
require 'base64'
require 'rubygems'
require 'sinatra'
require 'logger'
def get_voice_file(text,textnum,name,phone)

	log = Logger.new('/tmp/log')

	uri = URI("http://rospeex.nict.go.jp/nauth_json/jsServices/VoiceTraSS")

	output_dir = "/var/www/html/wav"
	
	uri.query = URI.encode_www_form( [
	["method","speak"],
	["params[]","ja"],
	["params[]", text],
	["params[]", "*"],
	["params[]","audio/x-wav"],
	["_","1503694759809"]
	]
	)

	res = Net::HTTP.get_response(uri)

	json_data=JSON.parse(res.body)

	log.info("#{phone}_")

	filename = "#{phone}_#{textnum}.wav"
	
	File.open("#{output_dir}/#{filename}", "w") do |f| 
		f.puts(Base64.decode64(json_data["result"]["audio"]))
	end
end

get '/create_wav_file' do 

	#リクエストパラメータから値を取得。
	name = params["name"].gsub!("\"","")
	number = params["personcount"].gsub!("\"","")
	ragtime = params["ragtime"].gsub!("\"","")
	phone = params["phonefrom"].gsub!("\"","")

	log = Logger.new('/tmp/clog')
	log.info("_#{name}_")
	log.info("_#{number}_")
	log.info("_#{ragtime}_")
	log.info("_#{phone}_")
	

	#p電話番号が聞き取りにくいため間に,を入れる
	tmp = phone
	tmp.split("")
	phone_for_voice = ("")
	
	phone.length.times { |i|
		phone_for_voice=phone_for_voice + tmp[i] + "、"
	}

	templates = [ 
		"予約システムから失礼いたします。#{name}と申します。席の予約をお願いできないでしょうか？",
		"時間は、本日#{ragtime}分後、人数は、#{number}名で、席だけの予約は可能でしょうか？",
		"予約可能な場合は、再度氏名と電話番号を申し上げますので、1を。予約不可能な場合は、2を。もう一度内容をお聞きになる場合は0を押してください。",
		"氏名は、#{name}と申します。電話番号は、#{phone_for_voice}です。",
		"ご対応ありがとうございました。",
		"予約は不可とのことで承知いたしました。ご対応いただき誠にありがとうございました。"
	]

	templates.each_with_index do |item,i|
		get_voice_file(item,i,name,phone)
	end
	response.headers["Access-Control-Allow-Origin"] = '*'
	'OK'
end
