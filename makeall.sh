#!/bin/bash

ORIGINAL_CWD=$(pwd)

./make.sh

cd tests
./make.sh
cd "${ORIGINAL_CWD}"

