#
# Be sure to run `pod lib lint PureDataKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PureDataKit'
  s.version          = '0.1.2'
  s.summary          = 'A lightweight library designed to integrate Pure Data (PD) audio synthesis and signal processing capabilities into iOS applications.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  PureDataKit is a lightweight library designed to integrate Pure Data (PD) audio synthesis and signal processing capabilities into iOS applications. This library leverages the work of the authors from the libpd/pd-for-ios project to provide a convenient and easy-to-use interface for embedding Pure Data functionality in iOS projects.

  Please note that I do not own any copyrights to the underlying library or the Pure Data components. All credit and copyrights belong to the original authors of libpd/pd-for-ios, who have done exceptional work in creating and maintaining this powerful tool. PureDataKit simply wraps their work to make it accessible to iOS developers in a streamlined manner.
                       DESC

  s.homepage         = 'https://github.com/EvansPie/PureDataKit.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Evangelos Pittas' => 'evangelospittas@gmail.com' }
  s.source           = { :git => 'https://github.com/EvansPie/PureDataKit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/EvansPie'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'PureDataKit/Classes/**/*', 'PureDataKit/Assets/Libraries/headers/*.h'
  
  # Link the static library
  s.vendored_libraries = 'PureDataKit/Assets/Libraries/libpd-ios-universal.a'
  
  # Framework dependencies
  s.frameworks = 'AudioToolbox', 'AVFoundation', 'Foundation'
  
  # Custom build settings Avoid `pod lib lint` errors when building for simulator
  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/PureDataKit/Assets/Libraries/headers"',
    'OTHER_LDFLAGS' => '-ObjC',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
