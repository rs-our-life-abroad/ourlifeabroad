FROM ruby:3.3.0

WORKDIR /app
COPY Gemfile* ./
RUN bundle install

COPY . .
RUN bundle exec jekyll build

FROM nginx:alpine
COPY --from=0 /app/_site /usr/share/nginx/html
EXPOSE 80