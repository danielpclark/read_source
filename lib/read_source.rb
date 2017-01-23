require 'read_source/version'
require 'read_source/vim_source'
require 'read_source/read_source'

module ReadSource
  ::Method.include VimSource
  ::Method.include ReadSource
  ::UnboundMethod.include VimSource
  ::UnboundMethod.include ReadSource
end
