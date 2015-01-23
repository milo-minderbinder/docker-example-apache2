FROM mminderbinder/apache2:0.9.15
MAINTAINER Milo Minderbinder <minderbinder.enterprises@gmail.com>

ENV HOME /root
CMD ["/sbin/my_init"]

# Disable default Apache site
RUN a2dissite 000-default

# Set up and enable www.example.com site
WORKDIR /etc/apache2
COPY ports.conf ./
COPY sites/www.example.com.conf ./sites-available/
RUN a2ensite www.example.com


# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
