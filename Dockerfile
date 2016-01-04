from tclavier/nginx

env DEBIAN_FRONTEND noninteractive

run apt-get update \
 && apt-get install -y -q \
    bundler \
    git \
    locales \
    ruby \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

run echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen

run mkdir -p /site
workdir /site
copy Gemfile /site/
copy Gemfile.lock /site/
run bundle install --system --quiet

copy _src/nginx_vhost.conf /etc/nginx/conf.d/azae.conf
copy . /site/

run LANG=en_US.UTF-8 jekyll build --destination /var/www
