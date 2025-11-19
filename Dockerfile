FROM ubuntu:latest as builder

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libcurl4-openssl-dev \
    zlib1g-dev

RUN git clone --recursive https://github.com/jupp0r/prometheus-cpp.git && \
    cd prometheus-cpp && \
    mkdir build && cd build && \
    cmake .. -DBUILD_SHARED_LIBS=ON && \
    make -j$(nproc) && \
    make install

RUN ls -l /usr/local/bin

COPY fibonacci.deb /tmp/fibonacci.deb
RUN dpkg -i /tmp/fibonacci.deb || apt-get install -f -y

RUN ls -l /usr/local/bin

RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/prometheus-cpp.conf && ldconfig

FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    libcurl4 \
    zlib1g

COPY --from=builder /usr/local/bin/fibonacci /usr/local/bin/fibonacci

COPY --from=builder /usr/local/lib/libprometheus-cpp-core.so* /usr/local/lib/
COPY --from=builder /usr/local/lib/libprometheus-cpp-pull.so* /usr/local/lib/
COPY --from=builder /usr/local/lib/libprometheus-cpp-push.so* /usr/local/lib/

RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/prometheus-cpp.conf && ldconfig

RUN ls -l /usr/local/bin && ls -l /usr/local/lib

RUN chmod +x /usr/local/bin/fibonacci

EXPOSE 8080

CMD echo "Запуск программы..." && /usr/local/bin/fibonacci || echo "Ошибка при запуске программы."