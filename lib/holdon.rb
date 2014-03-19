
module HoldOn

  class Timeout < StandardError
  end


  def self.until(options = {}, &block)
    self.breaker(options) do
      result = yield
      break result if result
    end
  end


  def self.while(options = {}, &block)
    self.breaker(options) do
      result = yield
      break result unless result
    end
  end


  # This method just introduces a delay into the code that
  # can be exited prematurely.  Useful when you are waiting
  # for something that *might* happen.
  def self.delay_until(options = {}, &block)
    begin
      self.until(options, &block)
    rescue HoldOn::Timeout
    end
  end


  # This method just introduces a delay into the code that
  # can be exited prematurely.  Useful when you are waiting
  # for something that *might* happen.
  def self.delay_while(options = {}, &block)
    begin
      self.while(options, &block)
    rescue HoldOn::Timeout
    end
  end


  def self.breaker(options = {})
    timeout  = options.fetch(:timeout, 30)
    interval = options.fetch(:interval, 1)
    message = options.fetch(:message, '')

    start = Time.now
    loop do
      yield

      # If the time remaining is less than the interval,
      # then we'll only sleep for the time remaining.
      inv = [interval, (timeout - (Time.now - start))].min
      if inv > 0
        sleep inv
      else
        raise Timeout, message
      end

    end
  end

end

