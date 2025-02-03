Pod::Spec.new do |s|
  s.name             = 'PureDataKit'
  s.version          = '0.1.3'
  s.summary          = 'A lightweight library designed to integrate Pure Data (PD) audio synthesis and signal processing capabilities into iOS applications.'
  
  s.description      = <<-DESC
  PureDataKit is a lightweight package designed to bridge the `lib-pd` static library in a Pod or Swift Package. This library leverages the work of the authors from the libpd/pd-for-ios project to provide a convenient and easy-to-use interface for embedding Pure Data functionality in iOS projects.
  
  Please note that I do not own any copyrights to the underlying library or the Pure Data components. All credit and copyrights belong to the original authors of libpd/pd-for-ios, who have done exceptional work in creating and maintaining this powerful tool. PureDataKit simply wraps their work to make it accessible to iOS developers in a streamlined manner.
    DESC
    
    s.homepage         = 'https://github.com/EvansPie/PureDataKit.git'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Evangelos Pittas' => 'evangelospittas@gmail.com' }
    s.source           = { :git => 'https://github.com/EvansPie/PureDataKit.git', :tag => s.version.to_s }
    s.social_media_url = 'https://github.com/EvansPie'
    
    s.ios.deployment_target = '12.0'
    s.swift_version = '5.0'
        
    # Link the static library
    # 👇 We could use `vendored_libraries` for the FAT universal static library, but we've already constructed a XCFramework woth its module map.
    #  s.vendored_libraries = 'PureDataKit/Assets/Libraries/libpd-ios-universal.a'
    s.vendored_frameworks = 'Sources/PureDataKit/Frameworks/PdWrapper.xcframework'
    
    s.frameworks = 'AudioToolbox', 'AVFoundation', 'Foundation'
    
    # Custom compiler flags
    s.compiler_flags = '-DPD', '-DUSEAPI_DUMMY', '-DHAVE_UNISTD_H', '-DLIBPD_EXTRA', '-fcommon'
    
    # Add the `ObjC` flag, and exclude unnecessary architectures that cause duplicate symbols
    s.pod_target_xcconfig = {
      'OTHER_LDFLAGS' => '-ObjC',
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
      'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'x86_64 i386'
    }
    
    s.user_target_xcconfig = {
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
      'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'x86_64 i386'
    }
  end
