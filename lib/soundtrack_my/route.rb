module SoundtrackMy
  class Route

    #based on carolines data of 2186 readings over 41 minutes
    SecondsPerReading = 1.1253430924062213

    #the mapmyrun api doesnt give us the start time, so just harcode it (this
    #is the time me and caroline went out to get test data)
    StartTime = Time.parse("2012-09-15 18:00:00")

    def initialize(route_id)
      @route_id = route_id
    end

    def output_for_pd
      data = route_data
      adapt_data(data)
      add_fake_time_data_to_markers(data)
      add_speed_to_data(data)
      data.to_json
    end

    private

      def adapt_data(data)
        data.map! do |row|
          { 'lat' => row['lat'],
            'lon' => row['lng'] }
        end
      end

      def route_data
        @route_data ||= MapMyRunRouteApiCall.new(@route_id).get_route_data
      end

      def add_fake_time_data_to_markers(markers)
        current_time = StartTime

        markers.each do |marker|
          marker['time'] = time_data_hash(current_time)
          current_time = current_time + SecondsPerReading
        end
      end

      def time_data_hash(time)
        { 'year' => time.year,
          'month' => time.month,
          'day' => time.day,
          'hour' => time.hour,
          'minute' => time.min,
          'second' => time.sec }
      end

      def add_speed_to_data(readings)
        total_dist = 0
        readings.each_with_index do |reading, idx|
          if idx == 0
            reading['speed'] = 0
            next
          end

          previous_reading = readings[idx-1]
          reading['speed'] = speed_between_readings(previous_reading, reading)

          total_dist = total_dist + distance_between_readings(previous_reading, reading)
        end
        #puts total_dist * 1000
      end

      def speed_between_readings(reading1, reading2)
        distance_between_readings(reading1, reading2) / SecondsPerReading
      end

      def distance_between_readings(reading1, reading2)
        lat1 = reading1['lat'].to_f
        lon1 = reading1['lon'].to_f
        lat2 = reading2['lat'].to_f
        lon2 = reading2['lon'].to_f

        #equations stolen from here:
        #http://www.movable-type.co.uk/scripts/latlong.html

        r = 6371;

        dLat = deg_to_rads(lat2-lat1)
        dLon = deg_to_rads(lon2-lon1)
        lat1 = deg_to_rads(lat1)
        lat2 = deg_to_rads(lat2)

        #puts "#{lat1},#{lon1},#{lat2},#{lon2}"

        a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2)
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1.0-a))
        d = r * c
      end

      def deg_to_rads(d)
        d * (Math::PI / 180)
      end

  end
end
