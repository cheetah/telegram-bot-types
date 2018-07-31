require 'dry/struct'

module Telegram
  module Bot
    module Types
      include Dry::Types.module

      Nil     = Strict::Nil
      Array   = Strict::Array
      Boolean = Strict::Bool
      String  = Coercible::String
      Integer = Coercible::Integer
      Float   = Coercible::Float

      class Base < Dry::Struct
        transform_keys(&:to_sym)

        transform_types do |type|
          if type.optional?
            type.meta(omittable: true)
          else
            type
          end
        end

        def [](key)
          super(key.to_sym)
        end

        def to_hash(*)
          super.reject { |_k, v| v.nil? }
        end
      end
    end
  end
end
