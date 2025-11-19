TARGET = fibonacci
CC = g++
CFLAGS = -Wall -Wextra -O2 -std=c++11 -I/usr/local/include
LDFLAGS = -L/usr/local/lib -lprometheus-cpp-core -lprometheus-cpp-pull -lprometheus-cpp-push -lcurl
SRCS = Fibi.cpp
DEPS_DIR = deps
PROMETHEUS_CPP = $(DEPS_DIR)/prometheus-cpp

# Основная цель
all: deps $(TARGET) install

# Установка зависимостей
deps: $(PROMETHEUS_CPP)

$(PROMETHEUS_CPP):
	@echo "Installing prometheus-cpp dependencies..."
	git clone https://github.com/jupp0r/prometheus-cpp.git $(PROMETHEUS_CPP)
	cd $(PROMETHEUS_CPP) && git submodule init && git submodule update
	mkdir -p $(PROMETHEUS_CPP)/build
	cd $(PROMETHEUS_CPP)/build && cmake .. -DBUILD_SHARED_LIBS=ON
	cd $(PROMETHEUS_CPP)/build && make -j4
	sudo make -C $(PROMETHEUS_CPP)/build install
	sudo ldconfig

# Сборка основной программы
$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) -o $(TARGET) $(LDFLAGS)

# Установка
install:
	mkdir -p ../usr/bin
	cp $(TARGET) ../usr/bin/

# Очистка
clean:
	rm -f $(TARGET)
	rm -rf $(DEPS_DIR)

# Переустановка
reinstall: clean all

.PHONY: all deps install clean reinstall