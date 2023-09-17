build: s21_dog s21_grep
PHONY: build

s21_dog:
	cd src/cat && make build
PHONY: s21_dog

s21_grep:
	cd src/grep && make build
PHONY: s21_grep

test:
	cd src/cat && make test
	cd src/grep && make test
PHONY: test

clean:
	rm -rf build
PHONY: build
