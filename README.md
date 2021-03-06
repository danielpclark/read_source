# ReadSource
[![Gem Version](https://badge.fury.io/rb/read_source.svg)](https://badge.fury.io/rb/read_source)
[![Build Status](https://travis-ci.org/danielpclark/read_source.svg?branch=master)](https://travis-ci.org/danielpclark/read_source)
[![SayThanks.io](https://img.shields.io/badge/SayThanks.io-%E2%98%BC-1EAEDB.svg)](https://saythanks.io/to/danielpclark)

Haha! This little gem was a distraction from my duties but I had to make it.

At first I was going to name it VIM-something because it lets you open the source code for a method in your VIM editor.
But as I thought about it I discovered it would be so simple to have Ruby read the method for itself. *Yes
I know there is the `method_source` gem that has been around forever.* But if I'm writing a VIM method
to read the source file I might as well throw in a method to string function.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'read_source'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install read_source

## Usage

This gem adds instance methods to the Method and UnboundMethod objects.

* `Method#vim`
* `Method#attr?`
* `Method#read_source`
* `UnboundMethod#vim`
* `UnboundMethod#attr?`
* `UnboundMethod#read_source`

Currently this assumes VIM is in your executable path.  Future versions of this gem will be more
accommodating to where VIM may be.

```ruby
require 'read_source'

require 'pathname'
puts Pathname.instance_method(:root?).read_source
#def root?
#  !!(chop_basename(@path) == nil && /#{SEPARATOR_PAT}/o =~ @path)
#end

Pathname.instance_method(:root?).attr?
# => nil

require 'prime'
puts Integer.method(:each_prime).read_source
#def Integer.each_prime(ubound, &block) # :yields: prime
#  Prime.each(ubound, &block)
#end

Gem::BasicSpecification.instance_method(:base_dir=).attr?
# => :attr_writer
```

You can type `vim` instead of the `read_source` method on either the `Method` or `UnboundMethod` objects
and it will close irb (or rails console) and open the source code file in VIM at the exact line where
the method is defined.

--- 

In case you didn't know Ruby already has a bunch of nice methods on `Method` and `UnboundMethod`
that are quite helpful.

```ruby
require 'read_source'
require 'pathname'

Pathname.method(:autoload).owner
# => Module 
Pathname.method(:pwd).owner
# => #<Class:Pathname>
Pathname.instance_method(:root?).source_location
# => ["/home/danielpclark/.rvm/rubies/ruby-2.3.1/lib/ruby/2.3.0/pathname.rb", 208]
```

---

NOTES:
* If the source code is written in C then the `read_source` and `vim` methods only return nil.
* If the file is in `GEM_HOME` path then VIM opens it in read only mode.

## VIM

We now support VIM servers and can open code directly into your existing VIM session(s).  If you've started
a VIM server with the name of "VIM" then any time you call the `vim` method it will open in there **unless**
you choose to specify another servername as a parameter to `vim`.

#### Start a VIM server with
```ruby
# A default server
vim --servername VIM

# An alternate server
vim --servername SOMENAME
```

Then to open the code in VIM you would do:

```ruby
# If a server is named VIM (or else it will close current Ruby session and open vim in this terminal).
Gem::BasicSpecification.instance_method(:base_dir=).vim

# Using a named server
Gem::BasicSpecification.instance_method(:base_dir=).vim 'SOMENAME'
```

This way you can keep your ruby code running and open the code in an existing VIM instance.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/danielpclark/read_source.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

