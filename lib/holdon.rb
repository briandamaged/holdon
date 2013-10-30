
module HoldOn

  class Timeout < Exception
  end


  def self.until(options = {}, &block)
    self.breaker(options) do
      result = yield
      break result if result
    end
  end



  def self.breaker(options = {})
    timeout  = options.fetch(:timeout, 30)
    interval = options.fetch(:interval, 1)

    start = Time.now
    loop do
      yield

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

