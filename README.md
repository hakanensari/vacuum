# Vacuum

![vacuum] [1]

[![travis] [2]] [3]

Vacuum is a [Nokogiri][4]-backed Ruby wrapper to the [Amazon Product
Advertising API] [5].

## Installation

Add to your Gemfile:

    gem 'vacuum'

## Configuration

Set up a locale:

    Vacuum.configure :uk do |c|
      c.key    = 'a key'
      c.secret = 'a secret'
      c.tag    = 'a tag'
    end

If you do not specify a locale, Vacuum will default to the US:

    Vacuum.configure do |c|
      c.key    = 'a key'
      c.secret = 'a secret'
      c.tag    = 'a tag'
    end

## The Request

Create a request for the above locale:

    req = Vacuum.new(:uk)

Again, if you don't specify a locale, the request will default to the
US:

    req = Vacuum.new

Search for something:

    req << { :operation    => 'ItemSearch',
             :search_index => 'All',
             :keywords     => 'George Orwell' }
    res = request.get

The following shorthand accomplishes the same search:

    res = req.search('George Orwell')

Customise your request:

    res = req.search('Books', :response_group => 'ItemAttributes',
                              :power          => 'George Orwell'

For all available methods and syntax, [read here] [6].

# The Response

Check if the response is valid:

    res.valid?

While it sounds quirky, a valid response may contain errors. Check for
those as well:

    res.has_errors?

Consume the entire response as a hash:

    res.to_hash

Preferably, drop down to a particular node and consume the relevant
bits and pieces you need:

    res.each('Item') do |item|
      # item['ASIN']
    end

[1]: https://github.com/hakanensari/vacuum/blob/master/vacuum.png?raw=true
[2]: https://secure.travis-ci.org/hakanensari/vacuum.png
[3]: http://travis-ci.org/hakanensari/vacuum
[4]: http://nokogiri.org/
[5]: https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html
[6]: https://github.com/hakanensari/vacuum/blob/master/lib/vacuum/operations.rb
