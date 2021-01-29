#
# Be sure to run `pod lib lint caid.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'caid'
  s.version          = '0.1.0'
  s.summary          = '计算caid可能用到的一些信息'
  s.homepage         = 'https://github.com/pdso/caid'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pdso' => 'pd@99d.in' }
  s.source           = { :git => 'https://github.com/pdso/caid.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'caid/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'CoreTelephony'
end
