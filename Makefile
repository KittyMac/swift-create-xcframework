#
# Makefile
# swift-create-xcframework
#
# Created by Rob Amos on 7/5/20.
#

PROJECTNAME := $(shell basename `pwd`)
PRODUCT := swift-create-xcframework
INSTALL_DIR := /usr/local/bin

# Override this on the command line if you need to
BUILD_FLAGS :=

.PHONY: build build-release install install-debug

default: build
build: build-debug

# Release Builds

build-release: $(wildcard Sources/*/*.swift)
	swift build --triple arm64-apple-macosx $(BUILD_FLAGS) --configuration release
	swift build --triple x86_64-apple-macosx $(BUILD_FLAGS) --configuration release
	-rm .build/${PROJECTNAME}
	lipo -create -output .build/${PROJECTNAME} .build/arm64-apple-macosx/release/${PROJECTNAME} .build/x86_64-apple-macosx/release/${PROJECTNAME}

install: build-release
	cp .build/release/swift-create-xcframework $(INSTALL_DIR)/$(PRODUCT)
	touch -c $(INSTALL_DIR)/$(PRODUCT)

# Debug builds

build-debug: $(wildcard Sources/*/*.swift)
	swift build $(BUILD_FLAGS) --configuration debug

install-debug: build-debug
	cp .build/debug/swift-create-xcframework $(INSTALL_DIR)/$(PRODUCT)
	touch -c $(INSTALL_DIR)/$(PRODUCT)

