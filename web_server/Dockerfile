#web server

FROM nginx

COPY hosts/ /etc/nginx/conf.d/

RUN apt-get update && \
    apt-get install -y composer vim

#COPY command.sh /tmp/command.sh
#RUN chmod +x /tmp/command.sh
#ENTRYPOINT /tmp/command.sh
#CMD ["nginx", "-g", "daemon off;"]