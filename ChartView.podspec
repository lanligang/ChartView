Pod::Spec.new do |s|

  s.name     = 'ChartView'

  s.version  = '0.0.1'

  s.license  = { :type => 'MIT' }

  s.summary  = '饼图、折线图、柱状图'

  s.description = <<-DESC
                    使用DrawRect绘制了一个 饼图、折线图、柱状图
                   DESC

  s.homepage = 'https://github.com/lanligang/ChartView'

  s.authors  = { 'LenSky' => 'lslanligang@sina.com' }

  s.source   = { :git => 'https://github.com/lanligang/ChartView.git', :tag => s.version }

  s.source_files = 'ChartView/**/*.{h,m}'
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
  s.ios.frameworks = ['UIKit', 'CoreGraphics', 'Foundation']
end