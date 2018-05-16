require 'pry'
class Factory

  def self.new(*args, keyword_init: false, &block)

    Class.new do
      # raise ArgumentError, 'wrong number of arguments (0 for 1+)' if args.length < 1
      # include Enumerable

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
      alias :eql? :==

      args.each do |attribute|
        attr_accessor attribute

        define_method :[] do |arg|
          if arg.is_a?(String) || arg.is_a?(Symbol)
            self.instance_variable_get("@#{arg}")
          elsif arg.is_a?(Integer)
            self.instance_variable_get("@#{args[arg]}")
          end
        end

        define_method :[]= do |arg, val|
          self.instance_variable_set("@#{arg}", val)
        end
      end

      # define_method :dig do
      #
      # end

      # define_method :each do
      #
      # end

      # define_method :each_pair do
      #
      # end

      # define_method :hash do
      #
      # end

      define_method :length do
        self.instance_variables.length
      end

      define_method :members do
        instance_variables.map { |member| member.to_s.gsub(/@/, '').to_sym }
      end

      define_method :select do |&block|
        block ? values.select(&block) : to_enum
      end

      define_method :to_a do
        arr_values = []
        self.instance_variables.each do |var|
          arr_values << self.instance_variable_get(var)
        end
        arr_values
      end

      define_method :to_h do
        keys = *args.map { |x| x = x.to_sym }
        values = []
        self.instance_variables.each do |val|
          value = instance_variable_get(val)
          values << value
        end
        h = keys.zip(values).to_h
        h
      end

      define_method :to_s do
        vars = lambda { |x| '%s="%s"' % [x[1..-1], instance_variable_get(x)] }
        '#<struct %s %s>' % [self.class, instance_variables.map(&vars).join(' ')]
      end

      define_method :values_at do |*indexes|
        self.values(*indexes)
      end

      alias :values :to_a
      alias :size :length
      alias :inspect :to_s
    end
  end
end

Cat = Factory.new("name", "age")
x = Cat.new('Tom', 5)
y = Cat.new('Tina', 7)
z = Cat.new('Tom', 5)

x == z
x == y

Arr = Factory.new("arr1", "arr2", "arr3")
t = Arr.new("ziro", "one", "two", "three")
c = Arr.new(0, 1, 2, 3)
c.select {|x| x.even?}
t[1]
t[1, 2]
c[1]
c[1, 2]
