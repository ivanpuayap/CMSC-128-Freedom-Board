require 'sinatra'
require 'yaml/store'
counter = 1

configure do 
  set :views , File.expand_path('../views', __FILE__) 
  
get '/' do
  erb :index
end

post '/submit' do 
  @variable1 = YAML.load_file("text.yml")
  @variable1.each do |final|
    counter += 1
  end

  time = Time.now
  @hour = time.strftime("%H").to_i
  @minutes = time.strftime("%M").to_i
  @seconds = time.strftime("%S").to_i

  @time = @hour*60*60 + @minutes*60 + @seconds
  @name = params['name'].split(/ |\_|\-/).map(&:capitalize).join(" ")
  @message = params['msg'].to_s
  @store = YAML::Store.new 'text.yml'
  @store.transaction do
    @store[counter] ||= {}
    @store[counter] = [@time, @name, @message]
    counter += 1
  end
  erb :index

end

post '/search' do
  @search = params['search']
  @load = YAML.load_file("text.yml")
  erb :search
end
