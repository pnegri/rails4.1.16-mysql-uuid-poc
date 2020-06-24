module Arel
  module Visitors
    class DepthFirst < Arel::Visitors::Visitor
      def visit_UUIDTools_UUID(o, a = nil)
        o.quoted_id
      end
    end

    class MySQL < Arel::Visitors::ToSql
      def visit_UUIDTools_UUID(o, a = nil)
        o.quoted_id
      end
    end
  end
end
