module CarrierWave
  module Uploader
    module Serialization
      def as_json(options=nil)
        serializable_hash
      end
    end
  end
end