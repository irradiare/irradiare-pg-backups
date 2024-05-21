
FROM postgres:16-bookworm

RUN apt-get -y update && apt-get -y --no-install-recommends install cron nano awscli gettext \
    && apt-get -y --purge autoremove && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN touch /var/log/cron.log
RUN touch /var/log/cron.out

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

ADD backup-scripts /backup-scripts
RUN chmod 0755 /backup-scripts/*.sh

WORKDIR /backup-scripts

ENTRYPOINT ["/bin/bash", "/backup-scripts/start.sh"]
CMD []