
# PureDataKit

`PureDataKit` is a Swift package and CocoaPod that wraps the `lib-pd` static library, enabling iOS developers to easily integrate **Pure Data** functionality into their apps. This package leverages the work of the authors from the `libpd/pd-for-ios` (https://github.com/libpd/pd-for-ios) project to provide a streamlined and user-friendly interface for embedding Pure Data in iOS projects.

Please note that **PureDataKit** does not own the copyrights to the underlying `libpd` library or the Pure Data components. All credit and copyrights belong to the original authors of the `libpd/pd-for-ios` project, who have done exceptional work in creating and maintaining this powerful tool. **PureDataKit** simply wraps their work to make it more accessible to iOS developers.

## How has it been implemented?

This package includes the `buildxcframework.sh` script, located in the `Scripts/` folder, which automates the creation of an XCFramework from the static library found in the `Libraries/` folder. The static library supports both `arm64` and `x86_64` architectures, and the resulting XCFramework will include these architectures, along with an umbrella header and a module map for seamless integration.

### Preparing the Static Library

If you're building from source, you may need to build the `libpd-ios-universal.a` static library and wrap it for iOS usage. The following shell script will help you with this process.

#### `buildxcframework` Script Usage

The provided shell script, `buildxcframework`, automates the process of preparing the `libpd-ios-universal.a` static library for iOS, checking for required architectures, generating module maps, and creating an `XCFramework`.

Here’s how to use it:

1. **Download or build the `libpd-ios-universal.a` library** and place it in the directory `Libraries/libpd/`.
2. **Place the library's public headers** in `Libraries/libpd/Headers`.
3. **Run the script** with the appropriate parameters.

#### Script Parameters

```bash
./buildxcframework.sh --library <library_path> --module-name <module_name> [--headers <headers_path>]
```

- `--library <library_path>`: The path to the `lib-pd` static library (`libpd.a` or `libpd.o`).
- `--module-name <module_name>`: The desired module name for the wrapper (e.g., `libpd`).
- `--headers <headers_path>` *(optional)*: The path to the directory containing the `lib-pd` header files.

#### Script Example

Here is how you might use the script, from the `Scripts/` folder:

```bash
./buildxcframework.sh --library ../Libraries/libpd/libpd-ios-universal.a --headers ../Libraries/libpd/Headers --module-name PdWrapper
```

This command will create the necessary `XCFramework` and ensure all headers and modules are correctly configured.

#### Script Workflow

1. **Architecture Check**: The script checks if the provided library contains both `arm64` and `x86_64` architectures. If not, it will exit with an error.

2. **Headers Check**: It verifies that the header files exist and contain at least one `.h` file.

3. **Umbrella Header Generation**: The script generates an umbrella header (`Umbrella-Header.h`) which imports all necessary header files for the library.

4. **Module Map Generation**: A `module.modulemap` is created to define how the Swift Package will interface with the C headers.

5. **Fat Library Splitting**: The script splits the fat library into architecture-specific libraries for `arm64` (device) and `x86_64` (simulator), ensuring compatibility across all iOS devices.

6. **XCFramework Creation**: The script creates an `XCFramework` containing the compiled libraries for both architectures.


## Installation

### Swift Package Manager (SPM)

To install `PureDataKit` using Swift Package Manager, add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/EvansPie/PureDataKit.git", from: "0.1.3")
]
```

### CocoaPods

To install via CocoaPods, add the following to your `Podfile`:

```ruby
pod 'PureDataKit', :git => 'https://github.com/EvansPie/PureDataKit.git', :tag => '0.1.3'
```

Then run:

```bash
pod install
```

> **Note:** Since August 2024 CocoaPods is in maintenance mode, and no new packages can be added. You can only install this package directly though Github.

## Usage

### Importing the Library

Once you've installed the package, you can import it into your Swift files like this:

```swift
import PdWrapper
```

- **libpd/pd-for-ios**: If you're unfamiliar with the `libpd` or `pd-for-ios` projects, please check out their documentation (https://github.com/libpd/pd-for-ios) to understand how they work. This package leverages their work to offer a cleaner and easier-to-use interface for iOS developers.


## Contributing

We welcome contributions to **PureDataKit**! If you'd like to contribute, please fork the repository and submit a pull request with your changes. Make sure to follow the contribution guidelines for code style, testing, and documentation.


## License

**PureDataKit** is licensed under the [MIT License](LICENSE).
