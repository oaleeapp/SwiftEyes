Pod::Spec.new do |s|

    s.name         = "SwiftEyes"
    s.version      = "0.1.4"
    s.summary      = "An easy way to access OpenCV library from Swift."
    s.homepage     = "https://github.com/oaleeapp/SwiftEyes"
    s.license      = { :type => '3-clause BSD', :file => 'LICENSE' }
    s.author             = { "Victor Lee" => "specialvict@gmail.com" }
    s.social_media_url   = "http://twitter.com/oaleeapp"
    s.platform     = :ios, "9.0"
    s.source           = { :git => 'https://github.com/oaleeapp/SwiftEyes.git', :tag => s.version.to_s }

    s.source_files = 'SwiftEyes/Classes/**/*'
    s.private_header_files = 'SwiftEyes/Classes/Private/*.h'

    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

    s.frameworks = "QuartzCore", "CoreVideo", "AssetsLibrary", "CoreMedia", "CoreImage", "CoreGraphics", "AVFoundation", "Accelerate", "UIKit", "ImageIO", "Foundation"
    s.libraries = "c++", "ObjC", "z"
    s.dependency 'OpenCV-Dynamic', '~> 3.2'

end
