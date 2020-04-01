EXECUTABLES := $(wildcard bin/*)
PREFIX ?= /usr/local

all:
	true

install: $(EXECUTABLES)
	install -d $(DESTDIR)$(PREFIX)/bin/
	install -m 755 -t $(DESTDIR)$(PREFIX)/bin $+ 
