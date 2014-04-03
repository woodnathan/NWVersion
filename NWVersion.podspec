Pod::Spec.new do |s|
  s.name         = 'NWVersion'
  s.version      = '0.1.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.summary      = 'A simple class to handle version strings'
  s.homepage     = 'https://github.com/woodnathan/NWVersion/'
  s.author       = { 'Nathan Wood' => 'nathan@appening.com.au' }
  s.source       = { :git => 'https://github.com/woodnathan/NWVersion.git', :tag => "v#{s.version}" }
  
  s.source_files = 'Source'
  s.requires_arc = true
  s.ios.deployment_target = '5.0' # Could be lower
  s.osx.deployment_target = '10.7' # Could be lower
end
