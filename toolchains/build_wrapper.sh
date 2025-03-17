#!/bin/bash

PROJECT_NAME=$1
TOOLCHAIN_IMAGE=$2
OUTPUT_FOLDER=$PWD/$3
ROOT=$PWD/project
BUILD=$ROOT/build
mkdir -p $BUILD
mkdir -p $OUTPUT_FOLDER

#Docker doesn't handle symlinks very well and using sandbox folder  creates unwanted artifacts in the repo
for file in "${@:4}";
do
    basepath=$(dirname $file)
    mkdir -p $ROOT/$basepath
    cp $file $ROOT/$basepath
done
#build artifacts necessary for flashing
docker run -v $ROOT:/project -v $BUILD:/project/build -w /project/$PROJECT_NAME -u $UID $TOOLCHAIN_IMAGE idf.py -B /project/build build

#move artifacts in bazel-out/bin folder
mv $BUILD/${PROJECT_NAME}.bin $OUTPUT_FOLDER
mv $BUILD/flasher_args.json $OUTPUT_FOLDER
mv $BUILD/partition_table/partition-table.bin $OUTPUT_FOLDER
mv $BUILD/bootloader/bootloader.bin $OUTPUT_FOLDER
