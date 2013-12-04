module Decode
  def decode_bson(bson)
    ActiveSupport::JSON.decode bson.to_json
  end

  def decode_json(json)
    ActiveSupport::JSON.decode json
  end
end