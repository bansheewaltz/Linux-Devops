FROM nginx:latest
COPY ./miniserver.c /home/
COPY ./run.sh /home/
RUN apt update; \
    apt install -y gcc \
                   libfcgi-dev \
                   spawn-fcgi; \
    rm -rf /var/lib/apt/lists/*; \
    chown -R nginx:nginx /etc/nginx/nginx.conf; \
    chown -R nginx:nginx /var/cache/nginx; \
    chown -R nginx:nginx /server; \
    touch /var/run/nginx.pid; \
    chown -R nginx:nginx /var/run/nginx.pid; \
    chown -R nginx:nginx /server && chmod -R 777 /server; \
    chown -R nginx:nginx /start_nginx.sh && chmod -R 777 /start_nginx.sh; \
    chmod u-s /usr/bin/gpasswd; \
    chmod u-s /usr/bin/newgrp; \
    chmod u-s /bin/su; \
    chmod u-s /bin/mount; \
    chmod u-s /bin/umount; \
    chmod u-s /usr/bin/chsh; \
    chmod u-s /usr/bin/chfn; \
    chmod u-s /usr/bin/chsh; \
    chmod u-s /usr/bin/passwd; \
    chmod g-s /usr/bin/expiry; \
    chmod g-s /usr/bin/wall; \
    chmod g-s /sbin/unix_chkpwd; \
    chmod g-s /usr/bin/chage;
WORKDIR /home
HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1
ENTRYPOINT ["sh", "run.sh"]
