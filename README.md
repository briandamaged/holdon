holdon
======

HoldOn until the specified condition is true


Usage
------

Let's say we're using [Capybara](https://github.com/jnicklas/capybara) to automate a web page.  Unfortunately, we need to interface with a bastard element that takes *forever* to load.  Have no fear: HoldOn is here!


    require 'capybara'
    require 'holdon'

    s = Capybara::Session.new :selenium
    s.visit "http://some.page.com"

    # Check for the element every 5 seconds.  Give up
    # after 60 seconds.
    e = HoldOn.until(timeout: 60, interval: 5, message: "waiting for bastard!") do
      s.first(:css, "div#bastard")
    end
    

Sure, that's pretty spiffy, but it relies on the "truthiness" of the value being returned.  Empty arrays are "truthy" in Ruby, so the above pattern would fail if we were trying to wait on a collection of elements.  No biggie -- we'll just use Holdon.breaker:


    rows = HoldOn.breaker(timeout: 60, interval: 5) do
      temp = s.all(:css, "tr")
      break temp unless temp.empty?
    end

