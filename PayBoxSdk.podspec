
Pod::Spec.new do |s|

 

  s.name         = "PBMvisaSdk"
  s.version      = "0.9.1"
  s.summary      = "PBMvisaSdk"
  s.description  = "mvisaSdk"
  s.homepage     = "http://paybox.money"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.pod_target_xcconfig = {'SWIFT_VERSION' => '4.0','LIBRARY_SEARCH_PATHS' => '$(SRCROOT)/PBMvisaSdk/'}
  s.author             = { "Arman" => "am@paybox.money" }
  s.public_header_files = 'PBMvisaSdk/*.h'
  s.ios.deployment_target = '12.1'
  s.requires_arc = true
  s.source       = { :git => "https://github.com/PayBox/PBMvisaSdk.git", :tag => "#{s.version}" }
  s.source_files  = 'PBMvisaSdk/*.{swift,h}', 'PBMvisaSdk/commonCrypto/*.{c,h}'
  s.libraries = 'z'
  
end
