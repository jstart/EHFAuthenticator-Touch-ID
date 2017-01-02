Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name         = "EHFAuthenticator-Touch-ID"
  s.version      = "0.0.5"
  s.summary      = "Simple class for handling Local Authentication using Touch ID. Used in eHarmony iOS App."

  s.description  = <<-DESC
                   EHFAuthenticator is a simple class to handle Touch ID security using the LocalAuthentication framework.  It manages a LAContext object and handles configuring the Touch ID alert with a proper reason and fallback button. 
                   DESC

  s.homepage     = "https://github.com/jstart/EHFAuthenticator-Touch-ID"
  s.screenshots  = "https://camo.githubusercontent.com/86f21615b1f9634734f2d07e03acc2c3adc4143a/68747470733a2f2f64323632696c623531686c7478302e636c6f756466726f6e742e6e65742f6d61782f323030302f312a6e67745061785864456a47724e70623735392d5433412e706e67"


  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "Christopher Truman" => "cleetruman@gmail.com" }
  s.social_media_url   = "http://twitter.com/iAmChrisTruman"
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/jstart/EHFAuthenticator-Touch-ID.git", :tag => s.version }

  s.default_subspec = "ObjC"
  s.subspec 'ObjC' do |objc|
    objc.source_files = "Authenticator-ObjC", "Authenticator-ObjC/*.{h.m}"
  end
  s.subspec 'Swift' do |swift|
    swift.source_files = "Authenticator-Swift", "Authenticator-Swift/*.swift"
    swift.platform     = :ios, "8.0"
  end

  s.framework  = "LocalAuthentication"

  s.requires_arc = true

end
