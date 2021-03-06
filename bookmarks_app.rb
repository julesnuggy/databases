require './lib/link.rb'
require './lib/db_connection_setup.rb'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/flash'
require 'uri'
require 'rake' # For use of Rack's HTTP verbs
require 'envyable'
Envyable.load('config/env.yml')

class Bookmarks < Sinatra::Base
  enable :sessions
  set :session_secret, 'My Secret Session'
  register Sinatra::Flash
  set :method_override, true

  get '/' do
    redirect '/links'
  end

  get '/links' do
    @links = Link.all
    erb(:index)
  end

  post '/links/add' do

    begin
      url_title = params[:url_title]
      url_address = URI.parse(params[:url_address])
      url_tags = params[:url_tags]
      url_comments = params[:url_comments]
    rescue
      flash[:invalid_bookmark] = "Add failed: invalid url link"
      redirect '/links'
    end

    if url_address.kind_of?(URI::HTTP)
      Link.add_bookmark(url_title, url_address, url_tags, url_comments)
      flash[:valid_bookmark] = "Bookmark added"

    else
      flash[:check_bookmark] = "Please check that your link is correct and includes the scheme (\'http\' or \'https\')"

    end

    redirect '/links'
  end

  patch '/links/update' do
    begin
      updated_id = params[:updated_id]
      updated_title = params[:updated_title]
      updated_address = URI.parse(params[:updated_address])
      updated_tags = params[:updated_tags]
      updated_comments = params[:updated_comments]
    rescue
      flash[:warning] = "Update failed: invalid url link"
      redirect '/links'
    end

    if updated_address.kind_of?(URI::HTTP)
      Link.update(updated_id, updated_title, updated_address, updated_tags, updated_comments)
      flash[:success] = "Bookmark updated"
    else
      flash[:info] = "Please check that your link is correct and includes the scheme (\'http\' or \'https\')"

    end

    redirect '/links'

  end

  delete '/links/delete' do
    @delete_id = params[:change_link_id]
    flash[:warning] = "Bookmark deleted"
    Link.delete(@delete_id)
    redirect '/links'
  end

  post '/links/search' do
    @search_query = params[:search_query]
    @links = Link.search(@search_query)
    erb(:index)
  end


  run! if app_file == $0
end
