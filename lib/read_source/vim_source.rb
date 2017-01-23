# TODO: Save irb history if in irb session.

module ReadSource
  module VimSource
    def vim servername=nil
      file, line_num = send :source_location
      read_only = !!/#{ENV["GEM_HOME"]}/.match(file) ? "-M" : ""
      remote = "#{('--servername ' + servername.to_s) if servername} --remote-silent"
      exec("vim #{remote} %s +%s %s" % [read_only, line_num, file]) if file
    end
  end
end
