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

RUN ldconfig

# Копируем исходный код и собираем приложение
COPY src/Fibi.cpp /app/
WORKDIR /app

RUN g++ -Wall -Wextra -O2 -std=c++11 -I/usr/local/include Fibi.cpp -o fibonacci \
    -L/usr/local/lib -lprometheus-cpp-core -lprometheus-cpp-pull -lprometheus-cpp-push -lcurl -lz

FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    libcurl4 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/fibonacci /usr/local/bin/fibonacci
COPY --from=builder /usr/local/lib/libprometheus-cpp-core.so.1.1 /usr/local/lib/
COPY --from=builder /usr/local/lib/libprometheus-cpp-pull.so.1.1 /usr/local/lib/
COPY --from=builder /usr/local/lib/libprometheus-cpp-push.so.1.1 /usr/local/lib/

RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/prometheus-cpp.conf && ldconfig

RUN chmod +x /usr/local/bin/fibonacci

EXPOSE 8080

CMD ["/usr/local/bin/fibonacci"]