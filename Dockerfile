# syntax = docker/dockerfile:1

# Use Ruby version ARG to make it dynamic
ARG RUBY_VERSION=3.3.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Set the working directory for the Rails app
WORKDIR /rails

# Set environment variables for production
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# Build stage to reduce final image size
FROM base as build

# Install necessary packages to build gems and Python
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    libvips \
    pkg-config \
    curl \
    nodejs \
    npm \
    python3 \
    python3-pip \
    python3-venv \
    libssl-dev \
    zlib1g-dev

# Install Yarn globally for managing TailwindCSS
RUN npm install --global yarn

# Set up Python environment and upgrade pip
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install -U --pre astroquery pandas

# Ensure Python environment is on the PATH
ENV PATH="/opt/venv/bin:$PATH"

# Install Rails gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Install TailwindCSS and its dependencies
COPY package.json yarn.lock ./
RUN yarn install

# Initialize TailwindCSS if not already
RUN yarn tailwindcss init

# Copy all application code
COPY . .

# Precompile assets for production
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final deployment stage
FROM base

# Install minimal runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libvips \
    postgresql-client \
    python3 \
    python3-pip && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy Python virtual environment from the build stage
COPY --from=build /opt/venv /opt/venv

# Ensure Python environment is on the PATH in the final image
ENV PATH="/opt/venv/bin:$PATH"

# Copy all built artifacts and environment
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run application as non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Entrypoint for database preparation
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose port 3000 for Rails server
EXPOSE 8080

# Default command for Foreman to start the app
CMD ["foreman", "start", "-f", "Procfile.dev"]