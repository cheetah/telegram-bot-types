require 'json'
require_relative 'types/base'

module Telegram
  module Bot
    module Types
      TYPES_FILE = File.expand_path('../types/types.json', __FILE__)

      class << self
        def define_types(file = TYPES_FILE)
          json = JSON.parse(File.read(file))

          json['types'].each { |type| Types.const_set(type['type'], Class.new(Base)) }
          json['sum'].each { |sum| define_sum(sum) }

          json['types'].each do |type|
            define_fields(Types.const_get(type['type']), type['fields'])
          end
        end

        def define_sum(sum)
          Types.const_set(
            sum['type'],
            sum['sum'].map { |x| Types.const_get(x) }.reduce(&:|)
          )
        end

        def define_fields(klass, fields)
          klass.class_eval do
            fields.each do |field|
              attribute field['field'].to_sym, Types.construct_type(field)
            end
          end
        end

        def construct_type(field)
          result = field['types'].map { |type| resolve_array_of(type) }.reduce(&:|)
          result = Types::Nil | result if field['optional']

          result
        end

        def resolve_array_of(type)
          if type.is_a?(::Array)
            base_type = Types.const_get(type.flatten.first)
            array_depth(type).times.reduce(base_type) { |acc, _| Types::Array.of(acc) }
          else
            Types.const_get(type)
          end
        end

        def array_depth(array)
          array.to_a == array.flatten(1) ? 1 : array_depth(array.flatten(1)) + 1
        end
      end

      define_types
    end
  end
end

require_relative 'types/response'
