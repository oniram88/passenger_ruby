# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM oniram88/ruby:2.1.3

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

#Installazione e predisposizione ruby
RUN \
    apt-get update && apt-get upgrade -y &&\
    gem install passenger  --no-ri --no-doc &&\
    mkdir -p /var/www

#    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /etc/service/passenger
ADD passenger_run.sh /etc/service/passenger/run
RUN chmod +x /etc/service/passenger/run