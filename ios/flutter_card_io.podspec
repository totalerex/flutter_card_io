#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_card_io'
  s.version          = '0.0.2'
  s.summary          = 'CardIO flutter plugin.'
  s.description      = <<-DESC
CardIO flutter plugin.
                       DESC
  s.homepage         = 'https://github.com/procedurallygenerated/flutter_card_io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'hello@world.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.resource_bundles = {
    'ScanAssets' => [
        'Assets/**/*.png'
    ]
  }
  s.dependency 'Flutter'
  s.dependency 'PayCardsRecognizer'
  s.ios.deployment_target = '10.0'
  s.static_framework = true
end

