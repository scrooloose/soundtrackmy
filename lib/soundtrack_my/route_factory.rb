module SoundtrackMy
  class RouteFactory
    def self.create_from_map_my_run_id(id, max_markers = 300)
      gps_readings = MapMyRunRouteApiCall.new(id).get_route_data
      DataThinner.new(gps_readings, max_markers).data
      Route.new(gps_readings)
    end

    def self.create_from_gpx_file(file_content, max_markers = 300)
      xml_doc = Nokogiri::XML.parse(file_content)
      data_hash = Hash.from_xml(xml_doc.to_s)
      reading_hashes = data_hash["gpx"]["trk"]["trkseg"]["trkpt"]

      gps_readings = reading_hashes.map do |reading_hash|
        GpsReading.new(reading_hash['lat'], reading_hash['lon'])
      end

      gps_readings = DataThinner.new(gps_readings, max_markers).data
      Route.new(gps_readings)
    end

  end
end
