# Usa una imagen con JRuby 9.4.13.0 y establece el directorio de trabajo
FROM --platform=linux/amd64 jruby:9.4.13.0-jdk11
RUN mkdir /holymusic-app-rails
WORKDIR /holymusic-app-rails

# Instala las dependencias necesarias
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  git \
  curl \
  postgresql-client \
  libpq-dev \
  build-essential \
  libxrender1 \
  libxext6 \
  libfontconfig1 \
  libfreetype6 \
  libjpeg-dev \
  libssl-dev \
  wkhtmltopdf \
  xfonts-base \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Instala Node.js 18 y yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g yarn

## System wkhtmltopdf binary will be used, no libjpeg symlink hacks needed

## OpenSSL 1.1 is available natively on bullseye via libssl1.1

# Copia los archivos necesarios al contenedor
COPY Gemfile Gemfile.lock ./
RUN jruby -S bundle install

# Instala foreman globalmente
RUN jruby -S gem install foreman

# Instala dependencias de Node.js
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

# Build assets
RUN yarn build
RUN yarn build:css

# Establece las variables de entorno necesarias para ejecutar la aplicación
ENV RAILS_ENV=development \
    WKHTMLTOPDF_PATH=/usr/bin/wkhtmltopdf

# Expone el puerto en el que se ejecutará la aplicación
EXPOSE 3000

# Inicia la aplicación
CMD ["jruby", "-S", "foreman", "start", "-f", "Procfile.dev"]
