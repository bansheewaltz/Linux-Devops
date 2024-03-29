.PHONY: build build_functional debug build_debug compiler build_compile_check\
		test test1 leak leaks style static linter verter clean rebuild re\
		os_info docker docker_prune install uninstall sign_code\
		gitignore

SRC := main.c parser.c processor.c error_outputs.c
PROGRAM := cat
PREFIX := s21_
BUILD_BIN_DIR := ../../build/bin
EXE := ${BUILD_BIN_DIR}/${PREFIX}${PROGRAM}
export EXE
# compile options
CC := gcc
WFLAGS := -Wall -Wextra -Werror
DEBUG_INFO := -g
D_DEBUG := -D DEBUG
# D_GNU_SRC := -D _GNU_SOURCE
STD := -std=c11
OPT := -O2
DFLAGS := -fsanitize=address -fno-omit-frame-pointer -fstack-protector-all\
		  -fsanitize=pointer-compare -fsanitize=pointer-subtract\
		  -fsanitize=leak -fsanitize=undefined -fsanitize=bounds-strict
# paths
DIR_PROJ_ROOT := ../..
DIR_SRC := ..
DIR_TESTS := ./testing
DIR_DOCKERFILES := $(DIR_PROJ_ROOT)/materials/build/custom_dockerfiles
DIR_SCRIPTS := $(DIR_PROJ_ROOT)/materials/build/custom_scripts
# environment-related
SHELL := /bin/bash
KERNEL := $(shell uname -s)
$(eval $(shell grep '^NAME' /etc/os-release 2>/dev/null)) # defines NAME(linux distro) shell varable
ifeq ($(KERNEL),Darwin)
	OS := MACOS
else
	ifeq ($(NAME),"Ubuntu")
		OS := UBUNTU
	else
		OS := ALPINE
	endif
endif
OS_MACRO := -D __${OS}__
ifndef VERBOSE
MAKEFLAGS += --no-print-directory
endif
DYNAMIC_SAMPLE := $(DIR_TESTS)/test_files/* 2>/dev/null


all: build
build:
	mkdir -p $(BUILD_BIN_DIR)
	$(MAKE) build_functional
build_functional: $(EXE)
$(EXE):
	$(CC) -o $(EXE) $(OS_MACRO) $(OPT) $(SRC)
debug:
	$(MAKE) clean
	$(MAKE) build_debug
build_debug:
	$(CC) -o $(EXE) $(DEBUG_INFO) $(D_DEBUG) $(OS_MACRO) $(SRC)
compiler:
	$(MAKE) clean
	$(MAKE) build_compile_check
build_compile_check: # separate task because of sanitizers don't work on ARM
	$(CC) -o $(EXE) $(DEBUG_INFO) $(OS_MACRO) $(WFLAGS) $(STD) $(SRC)
asan: clean
	$(CC) -o $(EXE) $(DEBUG_INFO) $(OS_MACRO) $(WFLAGS) $(STD) $(DFLAGS) $(SRC)
	@cd testing && utility=$(PROGRAM) bash test.sh
test: build
	printf "\ec"
	@cd $(DIR_TESTS) && utility=$(PROGRAM) bash test.sh
ttest: clean build
	printf "\ec"
	@./s21_grep &> /dev/null # at the first start of an executable macOS performs notarization which takes time
	@cd test_grep && time version=$(PROGRAM) mode=time bash test_func_grep.sh
	@echo
	@cd test_grep && time version=$(EXE)     mode=time bash test_func_grep.sh
complex: clean
	printf "\ec"
	$(MAKE) compiler
	@echo
	$(MAKE) style
	$(MAKE) static
	$(MAKE) dynamic
	@if [ $(OS) != "MACOS" ]; then\
		$(MAKE) asan;\
	fi
	$(MAKE) verter
valgrind: compiler
	@if [ -z "$$args" ]; then\
    	args="$(DYNAMIC_SAMPLE)";\
	fi;\
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes -s ./$(EXE) $$args
leak: build # fast check
	leaks -atExit -- ./$(EXE) $(DIR_TESTS)/test_files/* 2>/dev/null | grep -aE 'nodes|total|TOTAL|LEAK' | nl -b n
leaks: compiler
	@if [ -z "$$args" ]; then\
    	args="$(DYNAMIC_SAMPLE)";\
	fi;\
	leaks -atExit -- ./$(EXE) $$args 2>/dev/null | grep -aE 'nodes|total|TOTAL|LEAK' | nl -b n
dynamic: clean
	@printf "testing args: $(DYNAMIC_SAMPLE)\n\n"
	@if [ $(OS) == "MACOS" ]; then\
		$(MAKE) leaks;\
	else\
		$(MAKE) valgrind;\
	fi
	@echo
static:
	cppcheck --enable=all --suppress=missingIncludeSystem *.[ch]
	@echo
linter:
	bash $(DIR_SCRIPTS)/run_linter.sh
verter: docker_start
	$(MAKE) clean
	$(MAKE) -C ../cat/ clean
	cd $(DIR_PROJ_ROOT)/materials/build/ && bash run.sh
	@echo
clean:
	@rm -rf {$(EXE),logs,*.{out,log,dSYM,ntesting},*tmp*}
	@rm -rf $(DIR_TESTS)/{$(EXE),*.{out,log,dSYM,ntesting},*tmp*,logs}
	@rm -rf $(DIR_SRC)/.clang-format
rebuild: re
re:
	$(MAKE) clean
	$(MAKE) build


os_info:
	@echo KERNEL=${KERNEL}
	@echo NAME=${NAME}
	@echo INTERNAL_NAME=${OS}
	@echo MACRO=${OS_MACRO}
gitignore:
	@echo -e '\
	*\n\
	!*.[ch]\n\
	!Makefiie' > .gitignore
	@echo -e ".gitignore:\n"
	@cat .gitignore
docker_start:
	@if test $(OS) != "MACOS"; then\
		echo "Error: Docker can be run only on macOS for now";\
		exit 1;\
	fi
	@if test $(OS) == "MACOS" && ! pgrep -x "Docker" >/dev/null; then\
		echo "Starting Docker app...";\
		open -a Docker;\
		sleep 10;\
	fi
docker_install: # for ubuntu
	curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
docker: clean docker_start
	utility=$(PROGRAM) image=$(image) goal=$(goal) bash $(DIR_SCRIPTS)/run_docker.sh || true
docker_prune:
	yes | docker system prune -a
install: build
	sudo install -m 0755 $(EXE) /usr/local/bin
uninstall:
	sudo rm -f /usr/local/bin/$(EXE)
sign_code: # macOS only
	/usr/libexec/PlistBuddy -c "Add :com.apple.security.get-task-allow bool true" tmp.entitlements
	codesign -s - --entitlements tmp.entitlements -f $(EXE)
