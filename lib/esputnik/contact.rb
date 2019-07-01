# frozen_string_literal: true

module Esputnik
  Contact = Struct.new(:first_name,
                       :last_name,
                       :channels,
                       :address,
                       :fields,
                       :address_book_id,
                       :id,
                       :contact_key,
                       :orders_info,
                       :groups) do
    include ActiveModel::Validations

    validates_presence_of :channels

    def as_json
      hash = self.class.members.each_with_object({}) do |method_name, h|
        value = public_send(method_name)
        value = value.as_json if value.respond_to? :as_json
        h[method_name.to_s.camelize(:lower)] = value if value.present?
      end
      hash['channels'] = channels&.map(&:as_json)
      hash
    end
  end
end
