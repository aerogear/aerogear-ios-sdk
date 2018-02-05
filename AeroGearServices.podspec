## NOTE: this file will be used for podspec releases.
## Based on https://github.com/CocoaPods/Specs/blob/master/Specs/8/1/1/FirebaseCommunity/0.1.2/FirebaseCommunity.podspec.json

Pod::Spec.new do |s|
  s.name         = 'AeroGearServices'
  s.version      = '1.0.0'
  s.summary      = 'AeroGear Services Swift SDK for iOS.'

  s.description  = 'The AeroGear Services SDK for iOS provides a library to interact OpenShift based mobile services.'

  s.homepage     = 'http://aerogear.org'
  s.license      = 'Apache License, Version 2.0'
  s.authors      = 'AeroGear'
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/aerogear/aerogear-ios-sdk.git',
                     :tag => s.version}

  # ――― MULTI-PLATFORM VALUES ――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.requires_arc = true

  # --- Subspecs --- #

  s.subspec 'core' do |base|
    base.source_files = 'modules/core/**/*.swift'
    base.frameworks   = 'UIKit', 'Foundation', 'SystemConfiguration'
    base.dependency 'Alamofire', '4.6.0'
    base.dependency 'XCGLogger'
  end
end