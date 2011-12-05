
module Gtool
  module Util
    def ask_default(default, statement, color=nil)
      result = ask statement, color
      result = default if result.empty?
      result
    end
  end
end
