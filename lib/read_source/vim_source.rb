# TODO: Save irb history if in irb session.

module ReadSource
  module VimSource
    def vim servername=nil
      (file, line_num = send :source_location) || return
      read_only = !!/#{ENV["GEM_HOME"]}/.match(file) ? "-M" : ""
      remote = "#{('--servername ' + servername.to_s) if servername} --remote-silent"
      serverlist = `vim --serverlist`.split("\n")
      if serverlist.include?(servername.to_s) || serverlist.include?("VIM")
        `#{"vim #{remote} %s +%s %s" % [read_only, line_num, file]}` 
        :success
      else
        exec("vim #{remote} %s +%s %s" % [read_only, line_num, file])
      end
    end
  end
end
