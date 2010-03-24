require 'active_record'
module Lumberjack
  class Activity < ActiveRecord::Base
    
    belongs_to :source, :polymorphic => true
    belongs_to :object, :polymorphic => true
    
    def to_s(cache=true)
      if cache && defined?(self.cached_to_s) && !self.cached_to_s.blank?
        self.cached_to_s
      else
        "#{source.to_param} #{verb.to_past_tense} #{object.to_param}"
      end
    end
    
    def self.create_from_object(response, method, lumberjack_options={}, method_options={})
      if response.is_a? Hash
        activity = Activity.new(
          :source => response[:source],
          :verb => response[:verb],
          :object => response[:object]
        )
        if lumberjack_options[:cache] && defined?(activity.cached_to_s)
          activity.cached_to_s = activity.to_s
        end
        activity.save!
      else
        if lumberjack_options[:as] && !lumberjack_options[:as].blank?
          activity = Activity.new(
            :source => response.send(lumberjack_options[:as]),
            :verb => method,
            :object => response
          )
          if lumberjack_options[:cache] && defined?(activity.cached_to_s)
            activity.cached_to_s = activity.to_s
          end
          activity.save!
        else
          raise "Dumbass!"
        end
      end
      return response
    end
    
    
  end
end