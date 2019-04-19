Pod::Spec.new do |s|

  s.name         = "ACPSkeletonExtension"
  s.version      = "1.0.0"
  s.summary      = "Skeleton Extension for Adobe Experience Cloud SDK. Written and maintained by Your Company."
  s.description  = <<-DESC
                   The Skeleton Extension is a basic V5 Adobe Experience Cloud SDK extension implementation which provides a starting point for partner development.
                   DESC

  s.homepage     = "https://github.com/..."

  s.license      = {:type => "Commercial", :text => "Your Company.  All Rights Reserved."}
  s.author       = "Your Company's Awesome Team"
  s.source       = { :git => 'git@github.com/...', :tag => "v#{s.version}-#{s.name}" }
  s.platform = :ios, "10.0"
  s.requires_arc = true

  s.default_subspec = "iOS"

  s.dependency "ACPCore"
  s.subspec "iOS" do |ios|
    ios.vendored_libraries = "iOS/libACPSkeletonExtension.a"
    ios.source_files = "iOS/include/*.h"
    ios.frameworks = "UIKit", "SystemConfiguration"
    ios.libraries = "sqlite3.0", "c++", "z"
  end

end

