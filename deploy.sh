#!/bin/bash

BIN_DIR=build/bin
scp $BIN_DIR/* root@vm:/usr/local/bin
