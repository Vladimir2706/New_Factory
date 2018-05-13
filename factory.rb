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
        values = *args.map do |x|
          x = "@#{x}".to_s
        end
        values.each do |value|
          if self.instance_variable_get(value) == other.instance_variable_get(value)
            return true
          else
            return false
          end
        end
      end

      # D = Factory.new
      # binding.pry

      # define_method :[] do
      #
      # end
      #
      # define_method :[]= do
      #
      # end
      #
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
      # define_method :length do
      #
      # end
      #
      # define_method :members do
      #
      # end
      #
      # define_method :select do
      #
      # end
      #
      # define_method :size do
      #
      # end
      #
      # define_method :to_a do
      #
      # end
      #
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
z = Cat.new('Harfield', 5)

x == z
x == y
