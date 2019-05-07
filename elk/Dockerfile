FROM sebp/elk

RUN /opt/logstash/bin/logstash-plugin install logstash-input-beats

RUN apt-get update && apt-get install -y vim