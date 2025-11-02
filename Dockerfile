FROM ubuntu: latest
RUN apt-get update && apt-get install -y dpkg g++ build-essential
COPY fibonacci.deb /tmp/fibonacci.deb
RUN dpkg -i /tmp/fibonacci.deb || apt-get install -f
RUN chmod +x /usr/local/bin/fibonacci
ENTRYPOINT ["/usr/local/bin/fibonacci"]
CMD ["5"]