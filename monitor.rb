require 'rubygems'
require 'yaml'
require 'fileutils'
require 'bundler'

pwd = File.dirname(__FILE__)
Dir.chdir(pwd)
Bundler.require

servers = YAML.load_file("#{pwd}/servers.yml")["servers"]


responses = {}
filenames = {}
requests = []

servers.each do |server|
  config = server["server"]
  url = "#{config["host"]}:#{config["port"]}"
  final_url = "http://#{config["username"]}:#{config["password"]}@#{url}"
  filenames[final_url] = url
  requests << final_url
end


m = Curl::Multi.new
# add a few easy handles
requests.each do |url|
  responses[url] = ""
  c = Curl::Easy.new(url) do|curl|
    curl.follow_location = true
    curl.on_body{|data| responses[url] << data; data.size }
    # curl.on_success {|easy| puts "success, add more easy handles" }
  end
  m.add(c)
end

time_start = Time.now
time_str = time_start.strftime("%Y-%m-%d_%H-%M-%S")
date_str = time_start.to_date.to_s
hour = time_start.hour

root_dir = "#{pwd}/outputs"

out_dir = "#{root_dir}/#{date_str}/#{hour}"
FileUtils.mkdir_p(out_dir)

m.perform

requests.each do|url|
  filename = "#{out_dir}/#{filenames[url]}_#{time_str}.html"
  File.open(filename, "w"){|f| f.write responses[url] }
end