require 'dry/struct'

module Telegram
  module Bot
    module Types
      include Dry::Types.module

      # Collection of default types. They are also available without
      # `Types::` prefix in nested classes in opposite to other built-in types.
      Boolean = self::Bool.optional
      Integer = Coercible::Int.optional
      String = Coercible::String.optional
      Array = self::Array

      class Base < Dry::Struct
        constructor_type :schema
      end
    end
  end
end
