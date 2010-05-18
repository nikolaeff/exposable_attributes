# ExposableAttributes
module ExposableAttributes

  def self.included(base)
    base.send :extend, ClassMethods
  end

  DEFAULT_ACCESS_METHODS = [:xml, :json]

  module ClassMethods
    # Defines exposable attributes for AR object.
    #
    # == Examples
    # 
    #   class User < ActiveRecord::Base
    #     exposable_attributes :json, :only => [:id, :login]
    #     exposable_attributes :xml,  :except => [:encrypted_password, :salt, :single_access_token]
    #     exposable_attributes :json, :xml, :except => [:encrypted_password, :salt, :single_access_token]
    #   end
    def exposable_attributes(*attributes)
      init_default_accessors unless already_initialized?
      access_methods, options = parse_attributes(attributes)
      access_methods.each {|method_name| define_accessor(method_name, options) }
      send :include, InstanceMethods
    end

    private
      def init_default_accessors
        DEFAULT_ACCESS_METHODS.each {|method_name| define_accessor(method_name, {}) }
        set_initialization_flag
      end

      def set_initialization_flag
        cattr_accessor :exposable_attributes_initialized
        self.exposable_attributes_initialized = true
      end

      def already_initialized?
        self.respond_to? :exposable_attributes_initialized
      end

      def define_accessor(accessor_name, options)
        access_method_accessor = "exposable_#{accessor_name.to_s}_attributes"
        self.send(:cattr_accessor, access_method_accessor) 
        self.send("#{access_method_accessor}=", options)
      end

      def parse_attributes(attributes)
        access_methods = []
        options = {}

        if attributes.last.is_a?(Hash) then
           options = attributes.pop
          access_methods = attributes
        else
          options = { :only => attributes }
          access_methods = DEFAULT_ACCESS_METHODS
        end

        [access_methods, options]
      end
  end

  module InstanceMethods
    def to_xml(options = {})
      super(exposable_xml_attributes.merge(options))
    end

    def to_json(options = {})
      super(exposable_json_attributes.merge(options))
    end
  end

end

ActiveRecord::Base.send :include, ExposableAttributes
