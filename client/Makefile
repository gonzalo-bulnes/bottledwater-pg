SOURCES=replication.c protocol.c protocol_client.c connect.c api.c
EXEC_SRC=bwtest.c
EXECUTABLE=bwtest
STATICLIB=libbottledwater.a
SHAREDLIB=libbottledwater.so

PG_CFLAGS = -I$(shell pg_config --includedir) -I$(shell pg_config --includedir-server)
PG_LDFLAGS = -L$(shell pg_config --libdir) -lpq
AVRO_CFLAGS = $(shell pkg-config --cflags avro-c)
AVRO_LDFLAGS = $(shell pkg-config --libs avro-c)

WARNINGS = -Wall -Wmissing-prototypes -Wpointer-arith -Wendif-labels -Wmissing-format-attribute -Wformat-security
# _POSIX_C_SOURCE=200809L enables strdup
CFLAGS = -c -std=c99 -D_POSIX_C_SOURCE=200809L $(PG_CFLAGS) $(AVRO_CFLAGS) $(WARNINGS) -fPIC
LDFLAGS = $(PG_LDFLAGS) $(AVRO_LDFLAGS)
CC=gcc
AR=ar
OBJECTS=$(SOURCES:.c=.o)
EXEC_OBJ=$(EXEC_SRC:.c=.o)
SHARED_OBJ=$(SHARED_SRC:.c=.so)

.PHONY: all clean

all: $(SOURCES) $(EXECUTABLE) $(STATICLIB) $(SHAREDLIB)

$(EXECUTABLE): $(OBJECTS) $(EXEC_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(STATICLIB): $(OBJECTS)
	$(AR) rcs $@ $^

$(SHAREDLIB): $(OBJECTS)
	$(CC) -shared -fPIC -Wl,-soname,$(SHAREDLIB).0 -o $(SHAREDLIB).0.1 $(OBJECTS) -lc $(LDFLAGS)

.c.o:
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f $(OBJECTS) $(EXEC_OBJ) $(EXECUTABLE) $(STATICLIB)

install:
	cp libbottledwater.so.0.1 /usr/local/lib/libbottledwater.so.0.1
	ln -s /usr/local/lib/libbottledwater.so.0.1 /usr/local/lib/libbottledwater.so.0
	ln -s /usr/local/lib/libbottledwater.so.0.1 /usr/local/lib/libbottledwater.so
	cp api.h /usr/local/include/bottledwater.h
