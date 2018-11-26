Pod::Spec.new do |s|
 s.name = "ICEDebug"
 s.version = "0.0.1"
 s.summary = "A short description of WDPubLib pod."
 s.description = <<-DESC
 A longer description of MyPodDemo in Markdown format.
 * Think: Why did you write this? What is the focus? What does it do?
 * CocoaPods will be using this to generate tags, and improve search results.
 * Try to keep it short, snappy and to the point.
 * Finally, don't worry about the indent, CocoaPods strips it!
 DESC
 s.homepage = "git@github.wanda-group.net:wujianrong1/WDPubLib"
 s.license = {
    :type => 'Copyright',
    :text => <<-LICENSE
      Copyright 2016 Wanda All rights reserved.
      LICENSE
  }
 s.author = { "goingta" => "wujianrong1985@qq.com" }



 s.source = { :git => "git@github.wanda-itg.local:iOS/ICEDebug.git", :tag => "0.0.2" }



 s.source_files = 'classes/ICEDebug.h'
 s.public_header_files = 'classes/ICECore.h'
 s.requires_arc = true
 s.platform     = :ios, '7.0'

s.subspec 'ICEDebug' do |ss|
    ss.source_files = 'classes/**/*.{h,m}'
    ss.public_header_files = 'classes/**/*.h'
  end




s.framework = "AdSupport"

 end
