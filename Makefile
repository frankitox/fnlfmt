LUA ?= lua

DESTDIR ?=
PREFIX ?= /usr/local
BIN_DIR ?= $(PREFIX)/bin
MAN_DIR ?= $(PREFIX)/share/man/man1

SRC=cli.fnl fnlfmt.fnl
fnlfmt: $(SRC)
	echo "#!/usr/bin/env $(LUA)" > $@
	./fennel --require-as-include --compile $< >> $@
	chmod +x $@

selfhost:
	./fnlfmt --fix fnlfmt.fnl
	./fnlfmt --fix cli.fnl
	./fnlfmt --fix indentation.fnl
	./fnlfmt --fix macrodebug.fnl

# assumes you have a sibling checkout of Fennel
fennel.lua: ../fennel/fennel.lua ; cp $< $@
fennel: ../fennel/fennel ; cp $< $@

test: fnlfmt ; ./fennel test.fnl
count: ; cloc fnlfmt.fnl
clean: ; rm fnlfmt
lint: ; ./fennel --plugin ../fennel/src/linter.fnl -c fnlfmt.fnl > /dev/null

install: fnlfmt
	mkdir -p $(DESTDIR)$(BIN_DIR) && cp $< $(DESTDIR)$(BIN_DIR)/
	mkdir -p $(DESTDIR)$(MAN_DIR)
	cp fnlfmt.1 $(DESTDIR)$(MAN_DIR)/fnlfmt.1

uninstall:
	rm -f $(DESTDIR)$(BIN_DIR)/fnlfmt
	rm -f $(DESTDIR)$(MAN_DIR)/fnlfmt.1

check:
	fennel-ls --check $(SRC) indentation.fnl

.PHONY: selfhost test count roundtrip clean lint install check
