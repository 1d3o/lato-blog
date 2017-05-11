module LatoBlog
  class PostParent < ApplicationRecord

    # Validations:

    validates :publication_datetime, presence: true

    # Calbacks:

    before_validation do
      self.publication_datetime = DateTime.now if !self.publication_datetime
    end

  end
end
