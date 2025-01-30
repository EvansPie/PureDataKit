#!/bin/bash

# Set debug mode
set -x

# Clean up old files
rm -rf *.xcframework
rm -rf ./*-Thin

# Find `.a` files (static libraries)
find . -name '*.a' | while read -r FRAMEWORK
do
    FRAMEWORK_NAME="${FRAMEWORK%.*}"
    FRAMEWORK_NAME="$(basename -- "$FRAMEWORK_NAME")"
    echo "Framework is $FRAMEWORK_NAME"

    FRAMEWORK_THIN_FOLDER="${FRAMEWORK_NAME}-Thin"
    mkdir ${FRAMEWORK_THIN_FOLDER}

    ARCHS="x86_64 arm64" # Only extracting these two architectures, since xcframework won't take more anyways

    for ARCH in $ARCHS
    do
        echo "Extracting $ARCH from $FRAMEWORK"
        lipo -extract "$ARCH" "$FRAMEWORK" -o "${FRAMEWORK_THIN_FOLDER}/$FRAMEWORK_NAME-$ARCH.a"
    done

    echo "Creating XCFramework for $FRAMEWORK_NAME:"

    # Dynamically matching the header files
    case $FRAMEWORK_NAME in
        libpd-ios-universal)
        HEADERFILES=($(find ./headers -name "*.h"))  # Get all headers from the headers folder
        ;;

        lib1)
        HEADERFILES=("./headers/header1.h" "./headers/header2.h")
        ;;

        lib2)
        HEADERFILES=("./headers/header1.h" "./headers/header3.h")
        ;;

        lib3)
        HEADERFILES=("./headers/header1.h" "./headers/header2.h" "./headers/header3.h")
        ;;

        *)
        echo "No header files defined for $FRAMEWORK_NAME. Skipping..."
        continue
        ;;

    esac

    # Put Headers into place
    mkdir "${FRAMEWORK}"-Headers
    cp ${HEADERFILES[@]} "${FRAMEWORK}"-Headers/

    # Matching the -library and -headers parameters
    THINFRAMEWORKSFILES="$(find ${FRAMEWORK_THIN_FOLDER} -name "*.a")"
    THINFRAMEWORKSARRAY=($THINFRAMEWORKSFILES)

    echo "Building XCFramework for $THINFRAMEWORKSARRAY with ${HEADERFILES[@]/#/-headers }"
    xcodebuild -create-xcframework -library ${THINFRAMEWORKSARRAY[0]} -headers "${FRAMEWORK}"-Headers/ -library ${THINFRAMEWORKSARRAY[1]} -headers "${FRAMEWORK}"-Headers/ -output ${HEADERFILES[0]%.*}.xcframework

    # Remove Temp Headers
    rm -rf "${FRAMEWORK}"-Headers/ 
done

# Cleaning Thin Folders
rm -rf ./*-Thin
