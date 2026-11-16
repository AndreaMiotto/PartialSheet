Pod::Spec.new do |spec|
  spec.name                  = 'PartialSheet'
  spec.version               = '3.1.0'
  spec.summary               = 'PartialSheet 3.1.0 packaged for CocoaPods'
  spec.homepage              = 'https://github.com/quipper-dev/PartialSheet'
  spec.license               = { :type => 'MIT', :file => 'LICENSE' }
  spec.authors               = 'Andrea Miotto'
  spec.source                = { :git => 'https://github.com/quipper-dev/PartialSheet.git', :tag => "#{spec.version}-quipper" }
  spec.swift_versions        = ['5.0']
  spec.weak_frameworks       = 'SwiftUI'
  spec.ios.deployment_target = '15.0'
  spec.source_files          = 'Sources/PartialSheet/**/*.{swift}'
  spec.static_framework      = true
end
