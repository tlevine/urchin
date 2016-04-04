.PHONY: test install

test:
	./urchin tests
	./urchin -s sh ./cross-os-tests

install:
	cp ./urchin /usr/bin
