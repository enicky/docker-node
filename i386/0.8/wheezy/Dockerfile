FROM resin/i386-buildpack-deps:wheezy

ENV NODE_VERSION 0.8.28
ENV NPM_VERSION 2.10.1

RUN curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x86.tar.gz" \
	&& tar -xzf "node-v$NODE_VERSION-linux-x86.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-x86.tar.gz" \
	&& npm install -g npm@1.4.28 --unsafe-perm \
	&& npm install -g npm@"$NPM_VERSION" --unsafe-perm \
	&& npm cache clear \
	&& rm -rf /tmp/*

# note: we have to install npm 1.4.28 first because we can't go straight from 1.2 -> 2.0
# see also https://github.com/docker-library/node/issues/15#issuecomment-57879931

CMD [ "node" ]
