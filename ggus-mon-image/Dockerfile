FROM python:2.7-onbuild

ADD run.sh /
ADD kit-ca.crt /
ADD dfn-verein.crt /
RUN chmod +x /run.sh

RUN cp /*.crt /usr/local/share/ca-certificates/ && /usr/sbin/update-ca-certificates

ENTRYPOINT  /run.sh
