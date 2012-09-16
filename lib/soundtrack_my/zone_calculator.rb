module SoundtrackMy
  class ZoneCalculator
    Height = 100.0
    Width = 100.0

    def initialize(gps_readings)
      @gps_readings = gps_readings
    end

    def zone_number_for(reading)
      lat = reading.latitude - min_lat
      lat_zone = (lat / zone_lat_size).abs.floor

      lng = reading.longitude - min_lng
      lng_zone = (lng / zone_lng_size).abs.floor

      lat_zone + (lng_zone * Width)
    end

    private
      def zone_lat_size
        @zone_lat_size ||= (max_lat - min_lat) / (Width-1)
      end

      def zone_lng_size
        @zone_lng_size ||= (max_lng - min_lng) / (Height-1)
      end

      def max_lat
        @max_lat ||= @gps_readings.max do |a,b|
          a.latitude <=> b.latitude
        end.latitude
      end

      def min_lat
        @min_lat ||= @gps_readings.min do |a,b|
          a.latitude <=> b.latitude
        end.latitude
      end

      def max_lng
        @max_lng ||= @gps_readings.max do |a,b|
          a.longitude <=> b.longitude
        end.longitude
      end

      def min_lng
        @min_lng ||= @gps_readings.min do |a,b|
          a.longitude <=> b.longitude
        end.longitude
      end
    
  end
end
