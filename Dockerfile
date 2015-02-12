FROM mminderbinder/apache2:oracle-java7
MAINTAINER Milo Minderbinder <minderbinder.enterprises@gmail.com>


# Disable default Apache site
RUN a2dissite 000-default

# Set up and enable www.example.com site
COPY ports.conf /etc/apache2/ports.conf
COPY sites/www.example.com.conf /etc/apache2/sites-available/
RUN a2ensite www.example.com

# Set up OpenAM Apache Web Agent
RUN apt-get update && apt-get -y install unzip
RUN mkdir /opt/OpenAM
WORKDIR /opt/OpenAM
COPY Apache-v2.4-Linux-64-Agent-3.3.3.zip /opt/OpenAM/apache-agent.zip
RUN unzip apache-agent.zip

# Install OpenAM Apache Web Agent 
# with workaround for Debian/Ubuntu Apache2 config file name differences
ENV APACHEWA_BIN /opt/OpenAM/web_agents/apache24_agent/bin
WORKDIR $APACHEWA_BIN
COPY install_responses.txt $APACHEWA_BIN/install_responses.txt
COPY apachewa-installer.sh $APACHEWA_BIN/apachewa-installer.sh
RUN chmod 750 apachewa-installer.sh

# Expose ports defined in ports.conf
EXPOSE 80

# Run installer by default, since installer cannot be run if:
# 	1.) Apache2 is already running (so must be run before /sbin/my_init is called)
# 	2.) OpenAM server is not running and accessible (so must be called after OpenAM container is started)
CMD ["/bin/sh", "-c", "$APACHEWA_BIN/apachewa-installer.sh"]

# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
