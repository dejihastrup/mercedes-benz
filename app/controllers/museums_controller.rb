require 'open-uri'
require 'json'
require 'pry'
class MuseumsController < ApplicationController

  def home
  end

  def show
    @searched_museums = []
    url = "https://api.mapbox.com/geocoding/v5/mapbox.places/museum.json?proximity=-0.0770116,51.5328102&access_token=pk.eyJ1IjoiZGVqaWhhc3RydXAiLCJhIjoiY2tzMGd5aW5rMWp1dzJwcHNuNnBoaWJseCJ9.mBlCidO_rWFrgOqeCVjOEg"
    # url = "https://api.mapbox.com/geocoding/v5/mapbox.places/museum.json?proximity=#{params[:longitude]},#{params[:latitude]}&access_token=pk.eyJ1IjoiZGVqaWhhc3RydXAiLCJhIjoiY2tzMGd5aW5rMWp1dzJwcHNuNnBoaWJseCJ9.mBlCidO_rWFrgOqeCVjOEg"
    musuem_json = URI.open(url).string
    museums = JSON.parse(musuem_json)
    museums["features"].each do |museum|
      new_museum = Museum.new
      new_museum.name = museum["text"]
      new_museum.address = museum["place_name"].split(', ').drop(1).join(', ')
      new_museum.category = museum["properties"]["category"].split(', ').first.capitalize
      new_museum.longitude = museum["center"][0]
      new_museum.latitude = museum["center"][1]
      new_museum.save!
      @searched_museums << new_museum
    end

    @markers = @searched_museums.map do |museum|
      {
        lat: museum.latitude,
        lng: museum.longitude,
        info_window: render_to_string(partial: "info_window", locals: { museum: museum }),
        # image_url: 'https://www.pngkit.com/png/full/438-4389266_google-maps-orange-marker.png'
        image_url: helpers.image_path('museum.png')

      }
    end
  end

  # def map

  # end
end
