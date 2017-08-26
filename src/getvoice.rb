require 'net/http'
require 'json'
require 'base64'
require 'rubygems'
require 'sinatra'

def get_voice_file(text,textnum,name,phone)

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

	filename = "#{phone}_#{textnum}.wav"
	
	File.open("#{output_dir}/#{filename}", "w") do |f| 
		f.puts(Base64.decode64(json_data["result"]["audio"]))
	end
end

get '/create_wav_file' do 

	name = params["name"].gsub!("\""," ")
	number = params["number"].gsub!("\""," ")
	ragtime = params["ragtime"].gsub!("\""," ")
	phone = params["phone"].gsub!("\""," ")

	templates = [ 
		"予約システムから失礼いたします。#{name}と申します。席の予約をお願いできないでしょうか？",
		"時間は、本日#{ragtime}分後、人数は、#{number}名で、席だけの予約は可能でしょうか？",
		"予約可能な場合は、再度氏名と電話番号を申し上げますので、1を。予約不可能な場合は、2を。もう一度内容をお聞きになる場合は0を押してください。",
		"氏名は、#{name}と申します。電話番号は、#{phone}です。",
		"予約受付完了の場合は1を。再度情報をお聞きになる場合は2を押してください。",
		"予約は不可とのことで承知いたしました。ご対応いただき誠にありがとうございました。"
	]

	templates.each_with_index do |item,i|
		get_voice_file(item,i,name,phone)
	end
	'OK'
end
