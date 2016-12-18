require "read_source/version"

module ReadSource
  module VimSource
    def vim
      file, line_num = send :source_location
      read_only = !!/#{ENV["GEM_HOME"]}/.match(file) ? "-M" : ""
      exec("vim %s +%s %s" % [read_only, line_num, file]) if file
    end
  end
  module ReadSource
    def read_source
      (file, line_num = send :source_location) || return
      readlines = IO.readlines(file)
      source = readlines[line_num-1]
      indent = /\A[[:space:]]*/.match(source).to_s.length
      source = source[indent..-1]
      readlines[line_num..-1].each do |line|
        source += line[indent..-1]
        if indent == /\A[[:space:]]*/.match(line).to_s.length
          break source
        end
      end
    end
  end

  ::Method.include VimSource
  ::Method.include ReadSource
  ::UnboundMethod.include VimSource
  ::UnboundMethod.include ReadSource
end
