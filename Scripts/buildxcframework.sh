#!/bin/bash

# Enable error handling
set -e

# Function to display usage information
usage() {
    echo "Usage: $0 --library <library_path> --module-name <module_name> [--headers <headers_path>]"
    exit 1
}

# Function to check if the library contains both arm64 and x86_64 architectures
check_architectures() {
    local arch_info
    arch_info=$(lipo -info "$LIBRARY_PATH" 2>/dev/null)

    if [[ -z "$arch_info" ]]; then
        echo "Error: Invalid library file or lipo command failed."
        exit 1
    fi

    if [[ "$arch_info" != *"arm64"* || "$arch_info" != *"x86_64"* ]]; then
        echo "Error: Library must contain both arm64 and x86_64 architectures."
        echo "Found architectures: $arch_info"
        exit 1
    fi
}

# Function to check if the headers directory exists and contains at least one .h file
check_headers() {
    if [[ ! -d "$HEADERS_PATH" ]]; then
        echo "Error: Headers directory not found at $HEADERS_PATH"
        exit 1
    fi

    if [[ -z $(find "$HEADERS_PATH" -maxdepth 1 -name "*.h" -print -quit) ]]; then
        echo "Error: No .h header files found in $HEADERS_PATH"
        exit 1
    fi
}

# Function to check if the headers directory exists and contains at least one .h file
create_umbrella_header() {
    # Generate Pd.h file
    echo "Generating Umbrella Header..."
    UMBRELLA_HEADER="$HEADERS_PATH/Umbrella-Header.h"

    # Start with a header guard
    echo "// Auto-generated Umbrella-Header.h" > $UMBRELLA_HEADER
    echo "#ifndef UMBRELLA_HEADER_H" >> $UMBRELLA_HEADER
    echo "#define UMBRELLA_HEADER_H" >> $UMBRELLA_HEADER
    echo "" >> $UMBRELLA_HEADER

    # Iterate over all .h files in the Headers directory, excluding Pd.h
    for HEADER_FILE in "$HEADERS_PATH"/*.h; do
        FILE_NAME=$(basename "$HEADER_FILE")

        # Skip Pd.h itself and exclude files starting with "x_" or "z_"
        if [[ "$FILE_NAME" != "Umbrella-Header.h" ]]; then
            echo "#import \"$FILE_NAME\"" >> "$UMBRELLA_HEADER"
        fi
    done


    # Close the header guard
    echo "" >> $UMBRELLA_HEADER
    echo "#endif /* UMBRELLA_HEADER_H */" >> $UMBRELLA_HEADER

    echo "Umbrella-Header.h successfully generated at $UMBRELLA_HEADER"
}

generate_module_map() {
    # Generate module.modulemap
    echo "Generating module.modulemap..."
    MODULEMAP_FILE="$HEADERS_PATH/module.modulemap"

    # Start module definition
    echo "module $MODULE_NAME {" > $MODULEMAP_FILE
    echo "    umbrella header \"Umbrella-Header.h\"" >> $MODULEMAP_FILE
    echo "    export *" >> $MODULEMAP_FILE
    echo "    module * { export * }" >> $MODULEMAP_FILE
    echo "}" >> $MODULEMAP_FILE

    echo "module.modulemap successfully generated at $MODULEMAP_FILE"
}

split_fat_library() {
    echo "Splitting fat library into two separate architectures..."

    # Define output directories
    BUILD_DIR="../Libraries/libpd/build"
    rm -rf "$BUILD_DIR"
    IOS_DIR="$BUILD_DIR/Release-iphoneos"
    SIMULATOR_DIR="$BUILD_DIR/Release-iphonesimulator"
    
    # Create output directories if they don't exist
    mkdir -p "$IOS_DIR"
    mkdir -p "$SIMULATOR_DIR"

    # Extract the architectures
    lipo "$LIBRARY_PATH" -extract arm64 -o "$IOS_DIR/lib$MODULE_NAME.a"
    lipo "$LIBRARY_PATH" -extract x86_64 -o "$SIMULATOR_DIR/lib$MODULE_NAME.a"

    echo "Library split completed."

    # Copy header files
    echo "Copying headers to $IOS_DIR and $SIMULATOR_DIR..."

    cp -R "$HEADERS_PATH"/ "$IOS_DIR/Headers/"
    cp -R "$HEADERS_PATH"/ "$SIMULATOR_DIR/Headers/"

    echo "Headers copied successfully."
}

create_xcframework() {
    # Define output directory for XCFramework
    XCFRAMEWORK_DIR="../Sources/PureDataKit/Frameworks/"
    rm -rf "$XCFRAMEWORK_DIR"
    mkdir -p "$XCFRAMEWORK_DIR"

    # Define output directories
    BUILD_DIR="../Libraries/libpd/build"
    IOS_DIR="$BUILD_DIR/Release-iphoneos"
    SIMULATOR_DIR="$BUILD_DIR/Release-iphonesimulator"

    # Create the XCFramework
    echo "Creating XCFramework..."
    xcodebuild -create-xcframework \
        -library $IOS_DIR/lib$MODULE_NAME.a \
        -headers $IOS_DIR/Headers \
        -library $SIMULATOR_DIR/lib$MODULE_NAME.a \
        -headers $SIMULATOR_DIR/Headers \
        -output "$XCFRAMEWORK_DIR/$MODULE_NAME.xcframework"
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --library)
            LIBRARY_PATH="$2"
            shift 2
            ;;
        --module-name)
            MODULE_NAME="$2"
            shift 2
            ;;
        --headers)
            HEADERS_PATH="$2"
            shift 2
            ;;
        *)
            echo "Unknown parameter: $1"
            usage
            ;;
    esac
done

# Validate required parameters
if [[ -z "$LIBRARY_PATH" || -z "$MODULE_NAME" ]]; then
    echo "Error: Both --library and --module-name parameters are required."
    usage
fi

# Check if the library exists
if [[ ! -f "$LIBRARY_PATH" ]]; then
    echo "Error: Library file not found at $LIBRARY_PATH"
    exit 1
fi

# Validate architectures
check_architectures

# Validate headers if provided
if [[ -n "$HEADERS_PATH" ]]; then
    check_headers
    create_umbrella_header
    generate_module_map
    split_fat_library
    create_xcframework
fi

echo "Library Path: $LIBRARY_PATH"
echo "Module Name: $MODULE_NAME"
echo "Headers Path: ${HEADERS_PATH:-Not provided}"
echo "Library contains required architectures."
[[ -n "$HEADERS_PATH" ]] && echo "Headers are valid."
