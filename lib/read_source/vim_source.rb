module ReadSource
  module VimSource
    def vim
      file, line_num = send :source_location
      read_only = !!/#{ENV["GEM_HOME"]}/.match(file) ? "-M" : ""
      exec("vim %s +%s %s" % [read_only, line_num, file]) if file
    end
  end
end
