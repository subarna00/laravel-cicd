FROM composer:2


# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
# RUN delgroup dialout



WORKDIR /var/www/html
# RUN usermod --uid 1000 www-data
# RUN groupmod --gid 1000  www-data
