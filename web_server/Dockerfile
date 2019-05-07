#web server

FROM nginx

COPY hosts/ /etc/nginx/conf.d/

RUN apt-get update && \
    apt-get install -y composer
#    apt-get install -y curl && \
#    apt-get install -y gnupg
#
#RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
#
#RUN apt-get install -y nodejs && \
#    npm install -g typescript && \
#    npm install -g @angular/cli
#    npm install -g nodemon
#
#WORKDIR  /var/www/osds/backoffice
#CMD ng serve --host 0.0.0.0 --port 4200 --live-reload

#ADD nginx.conf /etc/nginx/

#COPY command.sh /tmp/command.sh
#RUN chmod +x /tmp/command.sh
#CMD /tmp/command.sh
