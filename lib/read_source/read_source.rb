module ReadSource
  module ReadSource
    def read_source
      (file, line_num = send :source_location) || return

      if file == "(irb)"
        warn "This feature doesn't work for code written in IRB!"
        return
      end

      is_inline_method = ->str{
        defs = str.scan(/def(?:\b|ine_method.*do)/).count
        ends = str.scan(/end/).count
        def_method_regex = /define_method[ (]+(?::|\w)+[ ),]+(?:{.*}|(?:instance_)?method\((?::|\w)+\)|&\w+)\)?/
        defs == ends || str =~ def_method_regex
      }

      readlines = IO.readlines(file)
      source = readlines[line_num-1]
      indent = /\A[[:space:]]*/.match(source).to_s.length
      source = source[indent..-1]
      return source if source.=~(/\A[[:space:]]*attr[\w]*/) || is_inline_method.(source)
      readlines[line_num..-1].each do |line|
        add_line = line =~ /\A[[:space:]]*\n\z/ ? "\n" : line[indent..-1]
        source += add_line
        if indent == /\A[[:space:]]*/.match(line).to_s.length
          break source
        end
      end
    end

    def attr?
      (file, line_num = send :source_location) || return

      if file == "(irb)"
        warn "This feature doesn't work for code written in IRB!"
        return
      end

      def_header = IO.readlines(file)[line_num-1]
      return unless def_header =~ /\A[[:space:]]*attr[\w]*/
      def_header[/attr[\w]*/].to_sym rescue nil
    end
  end
end
