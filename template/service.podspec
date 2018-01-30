Pod::Spec.new do |s|
  s.name         = '${SDK_NAME}'
  s.version      = '1.0.0'
  s.summary      = '${SDK_DESCRIPTION}'

  s.description  = '${SDK_DESCRIPTION}'

  s.homepage     = 'http://aerogear.org'
  s.license      = 'Apache License, Version 2.0'
  s.authors      = 'AeroGear'
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/aerogear/aerogear-ios-sdk.git',
                     :tag => s.version}
  s.source_files = '**/*.swift'
  s.frameworks   = 'UIKit', 'Foundation', 'SystemConfiguration'
  ## Add dependency here if needed
  ## s.dependency ''
  s.requires_arc = true
end
