module SoundtrackMy
  class GoogleMapsElevationApiCall
    BatchSize = 50

    def initialize(gps_readings)
      @gps_readings = gps_readings
    end

    def elevations
      elevations = []

      @gps_readings.each_slice(BatchSize) do |batch|
        elevations = elevations + elevations_for_batch(batch)
        sleep(2)
      end

      elevations
    end

    private

      def elevations_for_batch(batch)
        url = create_url(batch)
        response = HTTParty.get(url)
        extract_elevations_from(response)
      end

      def create_url(batch)
        
        locations = ""

        batch.each_with_index do |gps_reading,idx|
          locations += "#{gps_reading.latitude},#{gps_reading.longitude}"

          if idx != batch.size-1
            locations += "|"
          end
        end

        locations = CGI.escape(locations)

        "#{api_end_point}&locations=#{locations}"
      end

      def api_end_point
        "http://maps.googleapis.com/maps/api/elevation/json?sensor=false"
      end

      def extract_elevations_from(response)
        data = JSON.parse(response.body)

        if data['results'].empty?
          raise("No results - probably over query limit")
        end

        data['results'].map do |result|
          elevation = result['elevation']
          if elevation.nil? || elevation == ""
            raise("Malformed data")
          end

          elevation
        end
      end
  end
end
