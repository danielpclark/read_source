module ReadSource
  module ReadSource
    def read_source
      (file, line_num = send :source_location) || return
      readlines = IO.readlines(file)
      source = readlines[line_num-1]
      indent = /\A[[:space:]]*/.match(source).to_s.length
      source = source[indent..-1]
      return source if source =~ /(attr[\w]*)/
      readlines[line_num..-1].each do |line|
        source += line[indent..-1]
        if indent == /\A[[:space:]]*/.match(line).to_s.length
          break source
        end
      end
    end

    def attr?
      (file, line_num = send :source_location) || return
      def_header = IO.readlines(file)[line_num-1]
      def_header[/(attr[\w]*)/].to_sym rescue nil
    end
  end
end
