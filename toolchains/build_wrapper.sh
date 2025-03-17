#!/bin/bash

PROJECT_NAME=$1
TOOLCHAIN_IMAGE=$2
OUTPUT_FOLDER=$3
ROOT=$PWD/project
BUILD=$ROOT/build
mkdir -p $BUILD
echo $PROJECT_NAME $TOOLCHAIN_IMAGE $OUTPUT_FOLDER ${@:4}
#Docker doesn't handle symlinks very well and using sandbox folder  creates unwanted artifacts in the repo
for file in "${@:4}";
do
    basepath=$(dirname $file)
    mkdir -p $ROOT/$basepath
    cp $file $ROOT/$basepath
done
docker run -v $ROOT:/project -v $BUILD:/project/build -w /project/$PROJECT_NAME -u $UID $TOOLCHAIN_IMAGE idf.py -B /project/build build

mv $BUILD/${PROJECT_NAME}.bin $PWD/$OUTPUT_FOLDER
mv $BUILD/flasher_args.json $PWD/$OUTPUT_FOLDER
mv $BUILD/partition_table/partition-table.bin $PWD/$OUTPUT_FOLDER
mv $BUILD/bootloader/bootloader.bin $PWD/$OUTPUT_FOLDER
# mv $BUILD $1/