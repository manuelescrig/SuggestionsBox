Pod::Spec.new do |s|
  s.name             = "SuggestionsBox"
  s.version          = "0.1.0"
  s.summary          = "SuggestionsBox helps you build better a product trough your user suggestions."
  s.description      = <<-DESC
    Add SuggestionsBox to your project and build better a product trough your user suggestions.
                        DESC
  s.homepage         = "https://github.com/manuelescrig/SuggestionsBox"
  # s.screenshots     = https://cloud.githubusercontent.com/assets/1849990/15174018/cfd2f16c-175f-11e6-9a15-4708166834db.png"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Manuel Escrig Ventura" => "manuelescrig@gmail.com" }
  s.source           = { :git => "https://github.com/manuelescrig/SuggestionsBox.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/manuelescrig"
  s.ios.deployment_target = '8.0'
  s.source_files    = "SuggestionsBox/Classes/*.swift"

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
