TARGET = fibonacci
CC = g++
CFLAGS = -Wall -Wextra -O2
SRCS = Fibi.cpp

all: $(TARGET) install clean

$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) -o $(TARGET)

install:
	mkdir -p ../usr/bin
	cp $(TARGET) ../usr/bin/

clean:
	rm -f $(TARGET)