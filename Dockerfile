FROM ruby:2.2.3-slim

MAINTAINER Soumya Shetty <soumya.shetty@cerner.com>

RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for capybara-webkit
RUN apt-get install -y libqt4-webkit libqt4-dev xvfb

# for a JS runtime
RUN apt-get install -y nodejs

# sqlite
RUN apt-get install libsqlite3-dev

ENV APP_HOME how_i_see_the_world
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile Gemfile
 
COPY Gemfile.lock Gemfile.lock
 
# Prevent bundler warnings; ensure that the bundler version executed is >= that which created Gemfile.lock
RUN gem install bundler
 
# Finish establishing our Ruby enviornment
RUN bundle install
 
# Copy the Rails application into place
COPY . .

ADD . $APP_HOME

# Default command
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
