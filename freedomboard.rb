require 'sinatra'
require 'yaml/store'

#class Freedom_Board < Sinatra::Base
    get '/' do
        @title = 'Freedom Board'
        erb :index
    end

    count = 1

    post '/submit' do
        @title = 'Freedom Board!'
        @message = params['message']
        @sender = params['sender']
        time = Time.now.localtime("+08:00")
        @hour = time.strftime("%H").to_i
        @minutes = time.strftime("%M").to_i
        @seconds = time.strftime("%S").to_i
        @day = time.strftime("%d").to_i

        @time = @day*24*60*60 + @hour*60*60 + @minutes*60 + @seconds

        if (@sender == "")
          @sender = "Anonymous"
        end

        countentry = YAML.load_file "messages.yml"
        if countentry != false
            countentry.each do |entry|
                count += 1
            end
         end
                

        @sender = @sender.split(/ |\_|\-/).map(&:capitalize).join(" ")
        @store = YAML::Store.new 'messages.yml'
        @store.transaction do
            @store[count] = [@sender, @message, @time]
            count += 1
        end

        erb :index
    end

    post '/search' do

        @title = 'Freedom Board!'
        @search = params['search']
        if(@search == nil)
            @search = ""
        end
        erb :index
    end
#end
