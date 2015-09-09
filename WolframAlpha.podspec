Pod::Spec.new do |s|
  s.name = 'WolframAlpha'
  s.version = '0.1.2'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'WolframAlpha API client for Swift 2.0'
  s.homepage = 'https://github.com/romanroibu/WolframAlpha'
  s.authors = { 'Roman Roibu' => 'roman.roibu@gmail.com' }
  s.social_media_url = 'http://twitter.com/romanroibu'
  s.source = { :git => 'https://github.com/romanroibu/WolframAlpha.git', :tag => 'v0.1.2' }

  s.ios.deployment_target = '8.0'

  s.source_files = 'WolframAlpha/**/*.swift'

  s.requires_arc = true
end
