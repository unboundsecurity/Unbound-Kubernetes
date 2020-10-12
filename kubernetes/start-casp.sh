#!/bin/bash

./other/mongodb/start.sh $@
./ukc/start.sh $@
./other/postgres/start.sh $@
./casp/start.sh $@
