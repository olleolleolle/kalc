module Kalc
  module Ast

    class Expressions
      attr_reader :expressions

      def initialize(expressions)
        @expressions = expressions
      end

      def eval(context)
        last = nil
        @expressions.each do |exp|
          last = exp.eval(context)
        end
        last
      end
    end
    
    class FloatingPointNumber
      attr_reader :value
      
      def initialize(value)
        @value = value
      end

      def eval(context)
        Float(@value)
      end
    end

    class Arithmetic
      attr_reader :left
      attr_reader :right
      attr_reader :operator

      def initialize(left, right, operator)
        @left = left
        @right = right
        @operator = operator
      end

      def eval(context)

        @left = @left.eval(context)
        @right = @right.eval(context)

        case @operator.to_s.strip
        when '&&'
          @left && @right
        when '||'
          @left || @right
        when '<='
          @left <= @right
        when '>='
          @left >= @right
        when '=='
          @left == @right
        when '!='
          @left != @right
        when '-'
          @left - @right
        when '+'
          @left + @right
        when '*'
          @left * @right
        when '/'
          @left / @right
        when '%'
          @left % @right
        when '<'
          @left < @right
        when '>'
          @left > @right
        end
      end
    end

    class Conditional
      attr_reader :condition, :true_cond, :false_cond

      def initialize(condition, true_cond, false_cond)
        @condition = condition
        @true_cond = true_cond
        @false_cond = false_cond
      end

      def eval(context)
        @condition ? true_cond : false_cond
      end
    end

    class Identifier
      attr_reader :identifier
      attr_reader :value

      def initialize(identifier, value)
        @variable = identifier.to_s.strip
        @value = value
      end

      def eval(context)
        context.add_variable(@variable, @value.eval(context))
      end
    end

    class Variable
      attr_reader :variable
      def initialize(variable)
        @variable = variable
      end

      def eval(context)
        context.get_variable(@variable)
      end
    end

    class FunctionCall
      attr_reader :name
      attr_reader :variable_list

      def initialize(name, variable_list)
        @name = name
        @variable_list = variable_list
      end

      def eval(context)
        to_call = context.get_function(@name)
        to_call.call(context, @variable_list)
      end
    end
  end
end
