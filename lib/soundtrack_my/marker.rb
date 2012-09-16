module SoundtrackMy
  class Marker
    attr_reader :gps_reading
    attr_reader :elevation
    attr_reader :speed
    attr_reader :zone

    def initialize(gps_reading, elevation, speed, zone)
      @gps_reading = gps_reading
      @elevation = elevation
      @speed = speed
      @zone = zone
    end
  end
end
