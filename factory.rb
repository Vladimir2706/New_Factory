require 'pry'
class Factory

  def self.new(*args, keyword_init: false, &block)

    Class.new do
      include Enumerable

      define_method :initialize do |*val|
        raise ArgumentError, 'Too much arguments' if val.size > args.size
        raise ArgumentError, 'Wrong number of arguments' if val.size < args.size
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

      define_method :dig do |*args|
        self.to_h.dig(*args)
      end

      define_method :each do |&block|
        self.values.each(&block)
      end

      define_method :each_pair do |&block|
        self.to_h.each_pair(&block)
        self
      end

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
        self.values.to_a.values_at(*indexes)
      end

      alias :values :to_a
      alias :size :length
      alias :inspect :to_s
    end
  end
end
