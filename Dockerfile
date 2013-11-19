# DOCKER-VERSION 0.6.0

FROM ubuntu:12.04
MAINTAINER Andrew Hodgson <andrew@ratiopartners.com>

# Install dependencies
RUN echo 'deb http://us.archive.ubuntu.com/ubuntu/ precise universe' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y -qq curl git nginx-full

# Install kibana
RUN mkdir -p /src/kibana
RUN cd /src/kibana
RUN curl -sO https://download.elasticsearch.org/kibana/kibana/kibana-3.0.0milestone4.tar.gz
RUN tar --strip-components=1 -xzf kibana-3.0.0milestone4.tar.gz

# Add config
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./start-kibana.sh /src/start-kibana.sh

# Nginx port
EXPOSE 8080

CMD ["sh", "-ex", "/src/start-kibana.sh"]
