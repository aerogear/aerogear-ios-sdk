Pod::Spec.new do |s|
  s.name         = 'AGSPush'
  s.version      = '0.3.1'
  s.summary      = 'AeroGear Services AgsPush'

  s.description  = 'AeroGear Push SDK for iOS'

  s.homepage     = 'http://aerogear.org'
  s.license      = 'Apache License, Version 2.0'
  s.authors      = 'AeroGear'
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/aerogear/aerogear-ios-sdk.git',
                     :tag => s.version.to_s }
  s.source_files = 'modules/push/**/*.swift'
  s.frameworks   = 'UIKit', 'Foundation', 'SystemConfiguration'
  ## Default core dependency
  s.dependency 'AGSCore', s.version.to_s
  s.requires_arc = true
  
end
