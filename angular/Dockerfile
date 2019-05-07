FROM node

RUN npm install -g typescript && \
    npm install -g @angular/cli

WORKDIR  /var/www/osds/backoffice

#
CMD ng serve --host 0.0.0.0 --port 4200 --live-reload --disable-host-check