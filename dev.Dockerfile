# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="development" \
    BUNDLE_WITHOUT=""

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config curl

# Install Python and pip
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Activate the virtual environment and install dependencies
RUN /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install -U --pre astroquery pandas

# Set the path to use the virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install


# Copy the rest of the application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Create the user and set permissions
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails 

# Switch to the non-root user
USER rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-dev-entrypoint"]

# Remove pre-existing server.pid file if it exists
RUN rm -f /rails/tmp/pids/server.pid

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["foreman", "start", "-f", "Procfile.dev"]