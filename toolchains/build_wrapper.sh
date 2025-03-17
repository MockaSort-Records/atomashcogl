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
    #We want to replicate the same folder structure of the repo project + the generated files.
    #although, generated files are placed in a different place in the cache, 
    #the only way to achieve the goal is to scrape away all folders from the path till $PROJECT_NAME 
    #which is a consistent way in bazel build system folder structure to locate all artifacts for a given target name
    basepath=$(echo "$file" | sed -n "s|.*$PROJECT_NAME/\(.*/\).*|\1|p; s|.*$PROJECT_NAME/[^/]*$||p")
    #sometimes files are actually symlinks, docker doesn't like that.
    real_file=$(readlink $file)
    mkdir -p $ROOT/$basepath
    cp -r $real_file $ROOT/$basepath
done
#build artifacts necessary for flashing
docker run -v $ROOT:/project -v $BUILD:/project/build -w /project -u $UID $TOOLCHAIN_IMAGE idf.py -B /project/build build

#move artifacts in bazel-out/bin folder
mv $BUILD/${PROJECT_NAME}.bin $OUTPUT_FOLDER
mv $BUILD/flasher_args.json $OUTPUT_FOLDER
mv $BUILD/partition_table/partition-table.bin $OUTPUT_FOLDER
mv $BUILD/bootloader/bootloader.bin $OUTPUT_FOLDER
