# Utilisez une image Ruby officielle comme base
FROM ruby:3.2.2

# Installez les dépendances nécessaires
RUN apt-get update -qq && apt-get install -y nodejs npm

# Installez Yarn
RUN npm install -g yarn

# Définissez le répertoire de travail dans le conteneur
WORKDIR /app

# Copiez le Gemfile et Gemfile.lock
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Installez les gems
RUN bundle install

# Copiez le reste de votre application dans le répertoire de travail
COPY . /app

# Précompilez les assets (incluant Tailwind CSS)
RUN RAILS_ENV=development bundle exec rake assets:precompile

# Exposez le port 3000
EXPOSE 3000

# Lancez le serveur Puma de Rails
CMD ["rails", "server", "-b", "0.0.0.0"]
