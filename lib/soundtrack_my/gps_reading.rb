module SoundtrackMy
  class GpsReading
    attr_reader :latitude, :longitude

    def initialize(latitude, longitude)
      @latitude = latitude.to_f
      @longitude = longitude.to_f
    end
  end
end
