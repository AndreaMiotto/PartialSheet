Pod::Spec.new do |spec|
  spec.name     = 'PartialSheet'
  spec.version  = '1.0.3'

  spec.license  = { :type => 'MIT', :file => 'LICENSE' }
  spec.summary  = 'A custom SwiftUI modifier to present a Partial Modal Sheet'
  spec.homepage = 'https://github.com/AndreaMiotto/PartialSheet'
  spec.author   = { 'Andrea Miotti' => 'miotto.andrea@icloud.com' }
  spec.source   = { :git => 'https://github.com/AndreaMiotto/PartialSheet', :tag => "v#{spec.version}" }
  spec.module_name = 'PartialSheet'

  spec.swift_versions = ['5.0']
  spec.ios.deployment_target = '13.0'
  spec.osx.deployment_target = '10.15'
  
  spec.source_files = 'Sources/PartialSheet/*.swift'

end
