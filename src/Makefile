TARGET = fibonacci
CC = g++
CFLAGS = -Wall -Wextra -O2 -std=c++11 -I/usr/local/include
LDFLAGS = -L/usr/local/lib -lprometheus-cpp-core -lprometheus-cpp-pull -lprometheus-cpp-push -lcurl
SRCS = Fibi.cpp

all: $(TARGET) install

$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) -o $(TARGET) $(LDFLAGS)

install:
	mkdir -p ../usr/bin
	cp $(TARGET) ../usr/bin/

clean:
	rm -f $(TARGET)