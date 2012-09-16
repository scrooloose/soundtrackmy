module SoundtrackMy
  class Route

    #the mapmyrun api doesnt give us the start time, so just hardcode it
    StartTime = Time.parse("2012-09-15 18:00:00")

    def initialize(route_id)
      @route_id = route_id
    end

    def output_for_pd
      build_response.to_json
    end

    def get_readings
      gps_readings
    end

    private

      def build_response
        markers = build_markers

        full_response = {
          'journey' => {
            'markers' => markers.map { |m| marker_to_hash(m) }
          }
        }

        full_response.merge!(elevation_aggregate_details(markers))
        full_response.merge!(speed_aggregate_details(markers))
      end

      def build_markers
        readings = gps_readings
        elevations = elevations_for_readings(readings)

        zone_calculator = ZoneCalculator.new(readings)

        markers = []
        readings.each_with_index do |gps_reading, idx|
          speed = find_speed_for(gps_readings, idx)
          elevation = elevations[idx]
          zone = zone_calculator.zone_number_for(gps_reading)

          markers << Marker.new(gps_reading, elevation, speed, zone)
        end

        markers
      end

      def gps_readings
        @gps_readings ||= MapMyRunRouteApiCall.new(@route_id).get_route_data
      end

      def find_speed_for(gps_readings, idx)
        return 0 if idx == 0

        speed_calc = SpeedCalculator.new(gps_readings[idx], gps_readings[idx-1])
        speed_calc.speed
      end


      def elevations_for_readings(gps_readings)
        GoogleMapsElevationApiCall.new(gps_readings).elevations
      end

      def elevation_aggregate_details(markers)
        min = markers.min { |a,b| a.elevation <=> b.elevation }.elevation
        max = markers.max { |a,b| a.elevation <=> b.elevation }.elevation

        { 'min_elevation' => min,
          'elevation_range' => max - min }
      end

      def speed_aggregate_details(markers)
        min = markers.min { |a,b| a.speed <=> b.speed }.speed
        max = markers.max { |a,b| a.speed <=> b.speed }.speed

        { 'min_speed' => min,
          'speed_range' => max - min }
      end

      def marker_to_hash(m)
        { ele: m.elevation,
          speed: m.speed,
          zone: m.zone }
      end
  end
end
