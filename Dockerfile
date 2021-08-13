FROM python:3.7-alpine3.9

ENV OJ_ENV production

ADD . /app
WORKDIR /app
COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt
HEALTHCHECK --interval=5s --retries=3 CMD python2 /deploy/health_check.py

RUN apk add --update --no-cache build-base nginx openssl curl unzip supervisor jpeg-dev zlib-dev postgresql-dev freetype-dev && \
    apk del build-base --purge
RUN curl -L  $(curl -s  https://api.github.com/repos/thaitam/OnlineJudgeFE/releases/latest | grep /dist.zip | cut -d '"' -f 4) -o dist.zip && \
    unzip dist.zip && \
    rm dist.zip

ENTRYPOINT /app/deploy/entrypoint.sh
