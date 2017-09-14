# Alpine is a lightweight Linux
FROM mhart/alpine-node:6

# Update latest available packages
RUN apk update && \
    apk add ffmpeg && \
    apk add git && \
    rm -rf /var/cache/apk/* /tmp/* && \
    adduser -D app && \
    mkdir /tmp/torrent-stream && \
    chown app:app /tmp/torrent-stream && \
    npm install -g grunt-cli bower

WORKDIR /home/app
COPY . .
RUN chown app:app /home/app -R

# run as user app from here on
USER app
RUN npm install && \
    bower install && \
    grunt build

RUN mkdir -p  /home/app/.config/peerflix-server && \
    echo "[]" > /home/app/.config/peerflix-server/torrents.json

VOLUME [ "/tmp/torrent-stream" ]
EXPOSE 6881 9000

CMD [ "npm", "start" ]
