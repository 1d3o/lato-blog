module LatoBlog
  module PostField::SerializerHelpers

    def serialize_base
      serialized = {}

      # set basic info
      serialized[:key] = key
      serialized[:typology] = typology
      serialized[:value] = serialize_value

      # return serialized post
      serialized
    end

    private

    # This function returns the correct serialized value of the field.
    def serialize_value
      case typology
      when 'media'
        serialize_value_media
      when 'geolocalization'
        serialize_value_geolocalization
      else
        value
      end
    end

    # This function serialize a media value and return it.
    def serialize_value_media
      media = LatoMedia::Media.find_by(id: value)
      return unless media

      # add basic info
      serialized = {}
      serialized[:id] = media.id
      serialized[:title] = media.title
      serialized[:url] = media.attachment.url

      # add image info
      serialized[:thumb_url] = (media.image? ? media.attachment.url(:thumb) : nil)
      serialized[:medium_url] = (media.image? ? media.attachment.url(:medium) : nil)
      serialized[:large_url] = (media.image? ? media.attachment.url(:large) : nil)

      # return serialized media
      serialized
    end

    # This function serialize a geolocalization value and return it.
    def serialize_value_geolocalization
      return unless value
      value_object = eval(value)
      serialized = {}

      # add basic info
      serialized[:latitude] = value_object[:lat]
      serialized[:longitude] = value_object[:lng]
      serialized[:address] = value_object[:address]

      # return serialized data
      serialized
    end

  end
end
