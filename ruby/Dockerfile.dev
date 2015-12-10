FROM postgres:9.4

MAINTAINER Gonzalo Bulnes Guilpain
LABEL description.1="Provides a development environment for the Bottled Water Ruby adpater." \
      description.2="Runs the Ruby adapter test suite by default." \
      description.dockerfile.1="The Bottled Water Ruby adapter depends on the Bottled Water library." \
      description.dockerfile.2="This Dockerfile ensures that the Bottled Water library is only compiled when necessary," \
      description.dockerfile.3="and that the Ruby dependencies bundle is only updated when necessary," \
      description.dockerfile.4="so that updating the Ruby adapter development environment can be done as fast as possible."

# see https://askubuntu.com/a/506635
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies which don't change often
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y pkg-config
RUN apt-get install -y build-essential
RUN apt-get install -y postgresql-server-dev-9.4
RUN apt-get install -y curl
RUN apt-get install -y ruby
RUN apt-get install -y libffi-dev
RUN apt-get install -y ruby-dev
RUN apt-get install -y cmake

# Install libsnappy
# See https://github.com/confluentinc/bottledwater-pg/tree/v0.1#building
RUN apt-get install -y libsnappy-dev
RUN mkdir /usr/local/lib/pkgconfig
RUN echo "Name: libsnappy\nDescription: Snappy is a compression library\nVersion: 1.1.2\nURL: https://google.github.io/snappy/Libs: -L/usr/local/lib -lsnappy\nCflags: -I/usr/local/include\n" > /usr/local/lib/pkgconfig/libsnappy.pc

# Install Avro
WORKDIR /tmp
RUN curl http://apache.arvixe.com/avro/stable/c/avro-c-1.7.7.tar.gz > /tmp/avro-c-1.7.7.tar.gz
RUN tar -xzf /tmp/avro-c-1.7.7.tar.gz
RUN mkdir /tmp/avro-c-1.7.7/build
WORKDIR /tmp/avro-c-1.7.7/build
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/ -DCMAKE_BUILD_TYPE=RelWithDebInfo
RUN make
RUN make test
RUN make install

# Install Jansson
RUN apt-get install -y libjansson-dev

# Install libcurl
RUN apt-get install -y libcurl4-openssl-dev

# Install librdkafka
RUN apt-get install -y librdkafka-dev

# Build and install the libbottledwater shared library
# Add everything except the Ruby adapter files (to avoid invalidating the cache)
ADD ./Makefile /tmp/bottledwater/
ADD ./client/ /tmp/bottledwater/client/
ADD ./ext/ /tmp/bottledwater/ext/
ADD ./kafka/ /tmp/bottledwater/kafka/
WORKDIR /tmp/bottledwater
RUN make clean
RUN make client all
RUN make client install

# Install the Ruby dependencies manager
# this step is placed here for caching purpose
RUN gem install bundler
# Let's copy only the Gemfile and Gemfile.lock to
# avoid chache to be invalidated too often.
ADD ./ruby/Gemfile /tmp/bottledwater/ruby/Gemfile
ADD ./ruby/Gemfile.lock /tmp/bottledwater/ruby/Gemfile.lock
ADD ./ruby/bottled_water-pg.gemspec /tmp/bottledwater/ruby/bottled_water-pg.gemspec
ADD ./ruby/lib/bottled_water/pg/version.rb /tmp/bottledwater/ruby/lib/bottled_water/pg/version.rb
WORKDIR /tmp/bottledwater/ruby
# Installing the dependencies is pretty much all we can do at
# this point because other Ruby files haven't been added yet
RUN bundle install

# This last step cache will be invalidated every time a file
# of the Ruby adapter is modified
ADD ./ruby/ /tmp/bottledwater/ruby/
# Run the Ruby adapter test suite now that all files are available
WORKDIR /tmp/bottledwater/ruby
CMD rake
