
[topstack.io](http://topstack.io)
=================================
[![Build Status](https://travis-ci.org/stefan-lz/topstack.io.svg?branch=master)](https://travis-ci.org/stefan-lz/topstack.io)

Test yourself against some of the most asked questions on stackoverflow.

Dependencies
============
- [Ruby](https://www.ruby-lang.org)
- [PostgreSQL](http://www.postgresql.org)
- [Redis](http://redis.io)
- [StackApps API key](http://stackapps.com/apps/oauth/register)

Getting Started
===============
    git clone git@github.com:stefan-lz/topstack.io.git
    cd topstack.io
    bundle install
    bundle exec rake db:setup
    cp dot.env.example .env # edit file with stack app api keys
    rake # run the tests

License
=======
topstack.io is released under the [MIT License](http://www.opensource.org/licenses/MIT).
