# Usa una imagen de Ruby 2.7 y establece el directorio de trabajo
FROM ruby:3.2.1
RUN mkdir /holymusic-app-rails
WORKDIR /holymusic-app-rails

# Instala las dependencias necesarias
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client wkhtmltopdf

# Copia los archivos necesarios al contenedor
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
RUN ["cp", "/usr/bin/wkhtmltopdf", "/usr/local/bundle/bin/"]

# Establece las variables de entorno necesarias para ejecutar la aplicación
ENV RAILS_ENV development
ENV DATABASE_URL postgres://postgres@localhost/holymusic_app_rails_development

# Expone el puerto en el que se ejecutará la aplicación
EXPOSE 3000

# Inicia la aplicación
CMD ["rails", "server", "-b", "0.0.0.0"]
