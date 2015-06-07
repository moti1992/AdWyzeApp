class UserController < ApplicationController
	
	before_filter :authenticate_user!

	LAST_FM_API_KEY = "8cd2bead01d00bb268863165c20d4ae5"
  LAST_FM_GET_SIMILAR_URL = "http://ws.audioscrobbler.com/2.0/?method=artist.getsimilar"
  LAST_FM_GET_ARTIST_TRACKS = "http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks"

	def search
		@search = params[:search]

		if !params[:search].blank?
			@user = User.where(:id => params[:search])
		else
			@user = User.all
		end
	end

	def search_artist
		@search_artist = params[:search_artist]

		unless @search_artist.blank?
			UserHistory.create(user_id: current_user.id, terms: @search_artist)
			@url = "#{LAST_FM_GET_ARTIST_TRACKS}&artist=#{@search_artist}&api_key=#{LAST_FM_API_KEY}&format=json"
			@encoded_url = URI.encode(@url)
			@response = RestClient.get(@encoded_url, :content_type => :json, :accept => :json)
			@response = JSON.parse(@response)
			@artists = @response['toptracks']['track']
		else
			@artists = nil
		end
	end

	def get_similar_artists 
		@search_artist = UserHistory.where(user_id: current_user.id).last.terms

		Rails.logger.info @search_artist

		unless @search_artist.blank?
			@url = "#{LAST_FM_GET_SIMILAR_URL}&artist=#{@search_artist}&api_key=#{LAST_FM_API_KEY}&format=json"
			@encoded_url = URI.encode(@url)
			@response = RestClient.get(@encoded_url, :content_type => :json, :accept => :json)
			@response = JSON.parse(@response)
			@similar_artists = @response['similarartists']['artist']
		else
			@similar_artists = nil
		end
	end

	def search_history
		@artist_history = UserHistory.where(user_id: current_user.id).uniq.pluck(:terms)
	end

end
