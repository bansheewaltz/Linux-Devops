FROM nginx:latest
COPY ./nginx/nginx.conf /etc/nginx/
COPY ./miniserver.c /home/
COPY ./run.sh /home/
RUN apt update && \
    apt install -y gcc \
                   libfcgi-dev \
                   spawn-fcgi
WORKDIR /home
ENTRYPOINT ["sh", "run.sh"]
