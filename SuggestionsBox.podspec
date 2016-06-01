#
# Be sure to run `pod lib lint SuggestionsBox.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SuggestionsBox'
  s.version          = '1.0'
  s.summary          = 'SuggestionsBox helps you build better a product trough your user suggestions.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
An iOS library to aggregate users feedback about suggestions, features or comments in order to help you build a better product.
                       DESC

  s.homepage         = 'https://github.com/manuelescrig/SuggestionsBox'
  # s.screenshots     = 'https://cloud.githubusercontent.com/assets/1849990/15703910/2b646d9c-27e8-11e6-889c-0eee15ede7e3.jpg'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Manuel Escrig Ventura' => 'manuelescrig@gmail.com' }
  s.source           = { :git => 'https://github.com/manuelescrig/SuggestionsBox.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/manuelescrig'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SuggestionsBox/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SuggestionsBox' => ['SuggestionsBox/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
