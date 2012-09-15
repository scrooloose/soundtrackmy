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
      translate_data(data)
      add_fake_time_data_to_markers(data)
    end

    private

      def translate_data(data)
        data
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
  end
end
