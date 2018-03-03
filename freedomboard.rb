require 'sinatra'
require 'yaml/store'
counter = 1

set :views, Proc.new { File.join(root, "views") }
  get '/' do
    @searcher = false
    erb :index
  end

  post '/submit' do 
    @searcher = false
    @variable1 = YAML.load_file("text.yml")
    @variable1.each do |final|
      counter += 1
    end

    time = Time.now.localtime("+08:00")
    @hour = time.strftime("%H").to_i
    @minutes = time.strftime("%M").to_i
    @seconds = time.strftime("%S").to_i
    @day = time.strftime("%D").to_i

    @time = @day*24*60*60 + @hour*60*60 + @minutes*60 + @seconds
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
    @searcher = true
    @search = params['search']
    @load = YAML.load_file("text.yml")
    erb :index
  end

  post '/back' do
    @searcher = false
    erb :index
  end
