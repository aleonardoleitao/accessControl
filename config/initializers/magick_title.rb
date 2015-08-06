:root => "./",
:font => "PermanentMarker.ttf",
:font_path => Proc.new{ File.join MagickTitle.root, "fonts" },
:font_size => 50,
:destination => Proc.new{ File.join MagickTitle.root, "public/system/titles" },
:extension => "png",
:text_transform => nil,
:width => 800,
:height => nil,
:background_color => '#ffffff',
:background_alpha => '00',
:color => '#68962c',
:weight => 400,
:kerning => 0,
:line_height => 0,
:command_path => nil,
:log_command => false,
:cache => true,
:to_html => {
  :parent => {
    :tag   => "h1",
    :class => "image-title"
  },
  :class => "magick-title"
}