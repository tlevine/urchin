.PHONY: test install

test:
	./urchin tests
	./urchin -s sh -v ./cross-os-tests

install:
	cp ./urchin /usr/bin
