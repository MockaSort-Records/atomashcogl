#!/bin/bash

cd atomvm/src/platforms/esp32
/usr/bin/bash ./opt/esp/entrypoint.sh
idf.py -B /build build