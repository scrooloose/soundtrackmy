module SoundtrackMy
  class DataThinner
    def initialize(data, final_number)
      @data = data
      @final_number = final_number
    end

    def data
      @data = thin_readings if thinning_required?
      @data
    end

    private
      def thinning_required?
        @data.size > @final_number
      end

      def thin_readings
        n = drop_one_in_every_x
        result = (n - 1).step(@data.size - 1, n).map { |i| @data[i] }

        if result.size > @final_number
          result = result.first(@final_number)
        end

        result
      end

      def drop_one_in_every_x
        #flooring the result is done implicitly
        @data.size / @final_number
      end
  end
end
