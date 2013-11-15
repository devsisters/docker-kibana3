# DOCKER-VERSION 0.6.0

FROM ubuntu:12.04
MAINTAINER Andrew Hodgson <andrew@ratiopartners.com>

# Install dependencies
RUN echo 'deb http://us.archive.ubuntu.com/ubuntu/ precise universe' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y -qq git nginx-full

# Install kibana
RUN mkdir -p /src/kibana
RUN cd /src/kibana
RUN curl -Lks "https://download.elasticsearch.org/kibana/kibana/kibana-v3.0.0milestone4.tar.gz" | tar xz --strip-components=1

# Add config
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./start-kibana.sh /src/start-kibana.sh

# Nginx port
EXPOSE 8080

CMD ["sh", "-ex", "/src/start-kibana.sh"]
