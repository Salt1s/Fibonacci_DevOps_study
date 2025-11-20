# Этап сборки
FROM ubuntu:latest as builder

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libcurl4-openssl-dev \
    zlib1g-dev

# Клонируем и собираем prometheus-cpp
RUN git clone --recursive https://github.com/jupp0r/prometheus-cpp.git && \
    cd prometheus-cpp && \
    mkdir build && cd build && \
    cmake .. -DBUILD_SHARED_LIBS=ON && \
    make -j$(nproc) && \
    make install

# Проверим, что бинарник на месте
RUN ls -l /usr/local/bin

# Копируем и устанавливаем Debian-пакет
COPY fibonacci.deb /tmp/fibonacci.deb
RUN dpkg -i /tmp/fibonacci.deb || apt-get install -f -y

# Проверим, что бинарник на месте после установки
RUN ls -l /usr/local/bin

# Добавляем путь к библиотеке в ldconfig
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/prometheus-cpp.conf && ldconfig

# Финальный этап
FROM ubuntu:latest

# Устанавливаем необходимые зависимости для запуска
RUN apt-get update && apt-get install -y \
    libcurl4 \
    zlib1g

# Копируем бинарник из этапа сборки
COPY --from=builder /usr/local/bin/fibonacci /usr/local/bin/fibonacci

# Копируем библиотеки prometheus-cpp
COPY --from=builder /usr/local/lib/libprometheus-cpp-core.so* /usr/local/lib/
COPY --from=builder /usr/local/lib/libprometheus-cpp-pull.so* /usr/local/lib/
COPY --from=builder /usr/local/lib/libprometheus-cpp-push.so* /usr/local/lib/

# Добавляем путь к библиотеке в ldconfig
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/prometheus-cpp.conf && ldconfig

# Проверим, что бинарник и библиотеки на месте
RUN ls -l /usr/local/bin && ls -l /usr/local/lib

# Даем права на выполнение
RUN chmod +x /usr/local/bin/fibonacci

# Открываем порт
EXPOSE 8080

# Запускаем программу с диагностикой
CMD echo "Запуск программы..." && /usr/local/bin/fibonacci || echo "Ошибка при запуске программы."