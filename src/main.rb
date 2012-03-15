INITAT=Time.now.to_f
def show_time(tag="something")
  puts "#{tag}: #{( Time.now.to_f - INITAT )}"
end

$LOAD_PATH << 'src'

ruby_lib_path = File.join(File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))), "ruby").to_s()[5..-1] 
if File.exists?( ruby_lib_path ) 
  LIB_PATH = File.join(File.dirname(File.dirname(File.dirname(File.dirname(__FILE__))))).to_s()[5..-1] 
else 
  LIB_PATH = 'lib' 
end

require "swt_wrapper"
require "ui/splash_window"
SplashWindow.instance.replace('Loading...')
require "require_patch.rb"

require 'stringio'
require 'thread'
require "open-uri"
require "yaml"
%w{alert notification quit_window tray preference_panel report welcome_window}.each do | f |
  require "ui/#{f}"
end

require "app.rb"


begin
  App.require_compass

  begin
    require "ninesixty"
    require "html5-boilerplate"
    require "compass-h5bp"
  rescue LoadError
  end

  require "livereload"
  require "simplehttpserver"

  if App::CONFIG['show_welcome']
    WelcomeWindow.new
  end
  App.clear_autocomplete_cache

  Tray.instance.run(:watch => ARGV[0])

rescue Exception => e
  puts e.message
  puts e.backtrace
  App.report( e.message + "\n" + e.backtrace.join("\n"), nil, {:show_reset_button => true} )
  App.display.dispose

end
