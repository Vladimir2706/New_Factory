require 'pry'
class Factory

  def self.new(*args, keyword_init: false, &block)

    Class.new do
      # raise ArgumentError, 'wrong number of arguments (0 for 1+)' if args.length < 1
      # include Enumerable
      attr_accessor *args

      define_method :initialize do |*val|
        args.zip(val).each do |k, v|
          instance_variable_set("@#{k}", v)
        end
      end

      define_method :== do |other|
        values = *args.map { |x| x = "@#{x}".to_s }
        values.each do |value|
          if self.instance_variable_get(value) == other.instance_variable_get(value)
            return true
          else
            return false
          end
        end
      end

      define_method :[] do |arg|
        if arg.is_a?(String) || arg.is_a?(Symbol)
          self.instance_variable_get("@#{arg}")
        elsif arg.is_a?(Integer)
          self.instance_variable_get("@#{ args[arg] }")
        end
      end

      define_method :[]= do

      end

      # define_method :dig do
      #
      # end
      #
      # define_method :each do
      #
      # end
      #
      # define_method :each_pair do
      #
      # end
      #
      # define_method :eql? do
      #
      # end
      #
      # define_method :hash do
      #
      # end
      #
      # define_method :inspect do
      #
      # end
      #
      define_method :length do
        self.instance_variables.length
      end
      alias :size :length

      define_method :members do
        instance_variables.map { |member| member.to_s.gsub(/@/, '').to_sym }
      end
      #
      # define_method :select do
      #
      # end
      #
      # define_method :size do
      #
      # end

      define_method :to_a do
        arr_values = []
        self.instance_variables.each do |var|
          arr_values << self.instance_variable_get(var)
        end
        arr_values
      end

      # define_method :to_h do
      #
      # end
      #
      # define_method :to_s do
      #
      # end
      #
      # define_method :values do
      #
      # end
      #
      # define_method :values_at do
      #
      # end
    end
  end
end

Cat = Factory.new("name", "age")
x = Cat.new('Tom', 5)
y = Cat.new('Tina', 7)
z = Cat.new('Tom', 5)

x == z
x == y
