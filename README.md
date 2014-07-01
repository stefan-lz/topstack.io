topstack.io
===========
Test yourself against some of the most asked questions on stackoverflow. As seen [here](http://topstack.io)

What You Need
=============
- ruby
- postgres
- redis
- stackapps api key

Getting Started
===============
    git clone git@github.com:stefan-lz/topstack.io.git
    cd topstack.io
    bundle install
    bundle exec rake db:setup
    cp dot.env.example .env # edit file with stack app api keys
    rails s

License
=======
topstack.io is released under the [MIT License](http://www.opensource.org/licenses/MIT).
