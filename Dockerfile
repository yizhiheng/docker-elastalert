FROM gliderlabs/alpine:edge

MAINTAINER Jose Armesto <jose@armesto.net>

ENV LANG C.UTF-8
ENV ELASTALERT_HOME /opt/elastalert
ENV RULES_DIRECTORY ${ELASTALERT_HOME}/rules

WORKDIR /opt

RUN apk add --update \
    ca-certificates \
    python \
    python-dev \
    py-pip \
    build-base \
  && rm -rf /var/cache/apk/*

RUN wget https://github.com/Yelp/elastalert/archive/master.zip && \
    unzip -- *.zip && \
    mv -- elast* ${ELASTALERT_HOME} && \
    rm -- *.zip

WORKDIR ${ELASTALERT_HOME}

# Install Elastalert.
RUN python setup.py install && \
    pip install -e . && \
    mkdir ${RULES_DIRECTORY}

ENTRYPOINT ["/opt/elastalert/docker-entrypoint.sh"]
CMD ["python", "elastalert/elastalert.py", "--verbose"]

COPY ./docker-entrypoint.sh ${ELASTALERT_HOME}/docker-entrypoint.sh
COPY ./config.yaml ${ELASTALERT_HOME}/config.yaml

ADD ./rules ${RULES_DIRECTORY}/