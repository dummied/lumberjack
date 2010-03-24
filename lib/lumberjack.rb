require 'lumberjack/models/activity'
require 'lumberjack/inflections/inflectionist'
require 'lumberjack/inflections/inflections'
require 'lumberjack/inflections/string_ext'

ActiveSupport::Inflector.send(:extend, ParolkarInnovationLab::Inflectionist)

  module Lumberjack
    def self.included(base) #:nodoc:
      base.extend(ClassMethods)
    end
  
    module ClassMethods
    
      def lumberjacks(our_methods, our_options={})
        
        send :include, Lumberjack::InstanceMethods
        
        if our_methods.include?(:create)
          send(:after_create, Lumberjack::Chainsaw.new)
          Lumberjack::Chainsaw.settings = our_options
          puts Lumberjack::Chainsaw.settings
        end
        if our_methods.include?(:update)
          send(:after_update, Lumberjack::Chainsaw.new)
          Lumberjack::Chainsaw.settings = our_options
        end
        if our_methods.include?(:destroy)
          send(:before_destroy, Lumberjack::Chainsaw.new)
          Lumberjack::Chainsaw.settings = our_options
        end
        
        our_methods.reject{|u| [:create, :update, :destroy].include? u}.each do |our_method|
           to_eval = <<-EOR
            add_callback(:#{our_method}, {#{our_options.collect{|key, value| ":#{key} => :#{value}"}.join(", ")}})
           EOR
          eval to_eval
        end
      end
    end
      
      module InstanceMethods
        def self.included(base) # :nodoc:
          base.extend SingletonMethods
        end
        
        module SingletonMethods
          
          def add_callback(our_method, our_options)
            new_method = ("original_"+our_method.to_s).to_sym
            our_method = our_method
            string = our_method.to_s
            to_eval = <<-EOR       
              #{new_method.to_s} = self.instance_method(:#{our_method})
              define_method(:#{string}) do |*args,&block|
                response = #{new_method.to_s}.bind(self).call(*args,&block)
                Activity.create_from_object(response, "#{string.to_sym}", {#{our_options.collect{|key, value| ":#{key} => :#{value}"}.join(", ")}}, *args)
              end

            EOR
            self.instance_eval to_eval
            
          end
          
          
          
        end
        
        
      end
      
      class Chainsaw
        
        class << self; attr_accessor :settings end
        
        def after_create(record)
          Activity.create_from_object(record, "create", Lumberjack::Chainsaw.settings)
        end
        
        def after_update(record)
          Activity.create_from_object(record, "update", Lumberjack::Chainsaw.settings)         
        end
        
        def before_destroy(record)
          Activity.create_from_object(record, "destroy", Lumberjack::Chainsaw.settings)
        end
        
      end
    end  
