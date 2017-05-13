module Interkassa
  class BaseOperation
      attr_accessor :ik_shop_id, :secret_key

    def initialize(options={})
      options.replace(Interkassa.default_options.merge(options))

      @ik_shop_id = options[:ik_shop_id]
      @secret_key = options[:secret_key]
    end

  end
end