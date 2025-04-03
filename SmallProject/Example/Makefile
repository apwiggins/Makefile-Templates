# tool macros
CXX ?= g++
CXXFLAGS ?=
DBGFLAGS ?= -g
CCOBJFLAGS ?= $(CXXFLAGS) -c

# path macros
BIN_PATH := bin
OBJ_PATH := obj
SRC_PATH := src
DBG_PATH := debug

# compile macros
TARGET_NAME := main
ifeq ($(OS),Windows_NT)
    TARGET_NAME := $(addsuffix .exe,$(TARGET_NAME))
endif
TARGET := $(BIN_PATH)/$(TARGET_NAME)
TARGET_DEBUG := $(DBG_PATH)/$(TARGET_NAME)

# project name (fallback if not defined)
project_name ?= my_project

# src files & obj files
SRC := $(shell find $(SRC_PATH) -type f -name "*.c*")
OBJ := $(patsubst $(SRC_PATH)/%, $(OBJ_PATH)/%, $(SRC:.c=.o))
OBJ_DEBUG := $(patsubst $(SRC_PATH)/%, $(DBG_PATH)/%, $(SRC:.c=.o))

# clean files list
DISTCLEAN_LIST := $(OBJ) $(OBJ_DEBUG)
CLEAN_LIST := $(TARGET) $(TARGET_DEBUG) $(DISTCLEAN_LIST)

# default rule
default: makedir all

builder-build:
	docker build -f builder.Dockerfile -t $(project_name)-builder:latest .

builder-run:
	docker run --rm -it --platform linux/amd64 --workdir /builder/mnt \
		-v ${PWD}:/builder/mnt $(project_name)-builder:latest /bin/bash

# non-phony targets
$(TARGET): $(OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJ)

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CXX) $(CCOBJFLAGS) -o $@ $<

$(DBG_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CXX) $(CCOBJFLAGS) $(DBGFLAGS) -o $@ $<

$(TARGET_DEBUG): $(OBJ_DEBUG)
	$(CXX) $(CXXFLAGS) $(DBGFLAGS) -o $@ $(OBJ_DEBUG)

# phony rules
.PHONY: makedir
makedir:
	@mkdir -p $(BIN_PATH) $(OBJ_PATH) $(DBG_PATH)

.PHONY: all
all: $(TARGET)

.PHONY: debug
debug: $(TARGET_DEBUG)

.PHONY: clean
clean:
	@echo CLEAN $(CLEAN_LIST)
	@rm -f $(CLEAN_LIST)

.PHONY: distclean
distclean:
	@echo CLEAN $(DISTCLEAN_LIST)
	@rm -f $(DISTCLEAN_LIST)
