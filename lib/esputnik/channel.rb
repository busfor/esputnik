# frozen_string_literal: true

module Esputnik
  Channel = Struct.new(:type,
                       :value,
                       :device,
                       :web_push_subscription) do
    include ActiveModel::Validations

    validates_presence_of :type
    validates_presence_of :value

    def as_json
      self.class.members.each_with_object({}) do |method_name, h|
        value = public_send(method_name)
        value = value.as_json if value.respond_to? :as_json
        h[method_name.to_s.camelize(:lower)] = value if value.present?
      end
    end
  end
end
