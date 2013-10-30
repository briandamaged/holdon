
module HoldOn

  class Timeout < Exception
  end


  def self.until(options = {})
    timeout  = options.fetch(:timeout, 30)
    interval = options.fetch(:interval, 1)

    start = Time.now
    loop do
      result = yield
      return result if result

      # If the time remaining is less than the interval,
      # then we'll only sleep for the time remaining.
      inv = [interval, (timeout - (Time.now - start))].min
      if inv > 0
        sleep inv
      else
        raise Timeout
      end

    end
  end

end

