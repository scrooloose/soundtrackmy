module SoundtrackMy
  class SpeedCalculator
    #based on carolines data of 2186 readings over 41 minutes
    SecondsPerReading = 1.1253430924062213

    def initialize(reading1, reading2)
      @reading1 = reading1
      @reading2 = reading2
    end

    def speed
      km_per_second = distance_between_readings(@reading1, @reading2) / SecondsPerReading
      km_per_second * 1000
    end

    private

      def distance_between_readings(reading1, reading2)
        lat1 = reading1.latitude
        lon1 = reading1.longitude
        lat2 = reading2.latitude
        lon2 = reading2.longitude

        #equations stolen from here:
        #http://www.movable-type.co.uk/scripts/latlong.html

        r = 6371;

        dLat = deg_to_rads(lat2-lat1)
        dLon = deg_to_rads(lon2-lon1)
        lat1 = deg_to_rads(lat1)
        lat2 = deg_to_rads(lat2)

        a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2)
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1.0-a))
        d = r * c
      end

      def deg_to_rads(d)
        d * (Math::PI / 180)
      end

  end
end
