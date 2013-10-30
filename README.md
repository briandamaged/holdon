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
    e = HoldOn.until(timeout: 60, interval: 5) do
      s.first(:css, "div#bastard")
    end
    
    
