module Paperclip
  class VideoThumbnail < Processor

    attr_accessor :time_offset, :geometry, :whiny

    def initialize(file, options = {}, attachment = nil)
      super
      @time_offset = options[:time_offset] || '-4'
      unless options[:geometry].nil? || (@geometry = Geometry.parse(options[:geometry])).nil?
        @geometry.width = (@geometry.width / 2.0).floor * 2.0
        @geometry.height = (@geometry.height / 2.0).floor * 2.0
        @geometry.modifier = ''
      end
      @whiny = options[:whiny].nil? ? true : options[:whiny]
      @basename = File.basename(file.path, File.extname(file.path))

      #gera o arquivo com a marcadagua
      tmpVideoRemove = Tempfile.new([ @basename, 'tmp.mp4' ])
      tmpVideoRemove.binmode
      @tmpVideo = Tempfile.new([ @basename, '.mp4' ])
      @tmpVideo.binmode

      begin
        @resultMarca = system( "ffmpeg -i #{File.expand_path(file.path)} -ss 00:00:00 -t 00:00:05 -c:v copy -c:a copy -c:s copy -map 0:0 -map 0:1 #{File.expand_path(tmpVideoRemove.path)} -y")
        @resultMarca = system( "ffmpeg -i #{File.expand_path(tmpVideoRemove.path)} -i #{File.expand_path("app/assets/images/marcadagua.png")} -filter_complex overlay='(main_w/2)-(overlay_w/2):(main_h/2)-(overlay_h)/2' #{File.expand_path(@tmpVideo.path)} -vcodec mjpeg -y" )
      rescue PaperclipCommandLineError => e
        Rails.logger.error e
      end      

    end

    def make

      dst = Tempfile.new([ @basename, 'jpg' ].compact.join("."))
      dst.binmode

      cmd = %Q[-itsoffset #{time_offset} -i "#{File.expand_path(@tmpVideo.path)}" -y -vcodec mjpeg -vframes 3 -an -f rawvideo ]
      cmd << "-s #{geometry.to_s} " unless geometry.nil?
      cmd << %Q["#{File.expand_path(dst.path)}"]

      begin
        success = Paperclip.run('ffmpeg', cmd)

      rescue PaperclipCommandLineError
        raise PaperclipError, "There was an error processing the thumbnail for #{@basename}" if whiny
      end
      dst
    end
  end
end