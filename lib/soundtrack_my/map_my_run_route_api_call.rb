require 'json'
require 'httparty'

module SoundtrackMy

  class MapMyRunRouteApiCall
    def initialize(route_id)
      @route_id = route_id
    end

    def get_route_data
      url = route_call_url
      data = make_api_call(url)
      extract_coordinates(data)
    end

    private

    def make_api_call(url)
      response = HTTParty.get(url)
      JSON.parse(response.body)
    end

    def route_call_url
      "#{api_end_point}/routes/get_route?&o=json&route_id=#{@route_id}&display_marker_interval=100"
    end

    def api_end_point
      "http://api.mapmyfitness.com/3.1"
    end

    def extract_coordinates(data)
      data['result']['output']['points']
    rescue
      raise("Malformed data")
    end
  end

end
