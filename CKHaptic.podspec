#
# Be sure to run `pod lib lint CKHaptic.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CKHaptic'
  s.version          = '0.1.3'
  s.summary          = 'Play your custom haptic feedback with ease.'

# This description is used to generate tags and improve search results.
  s.description      = <<-DESC
Play your custom haptic feedback with ease. With a few strings, you can create various mixes of haptic vibration. This SDK provides two types of haptics - Buzz and Beat, which you can customize with the variables such as intensity and sharpness. Under the hood it uses native Core Haptics library. The Buzz corresponds to 'hapticContinuous' and Beat to 'hapticTransient'. The intensity and sharpness are the same as in Core Haptics.
                       DESC

  s.homepage         = 'https://github.com/chungchung1315/CKHaptic'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Marcel' => 'chungchung1315@gmail.com' }
  s.source           = { :git => 'https://github.com/chungchung1315/CKHaptic.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'CKHaptic/Classes/**/*'
  
  s.frameworks = 'CoreHaptics'  
end
