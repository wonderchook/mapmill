class Vote < ActiveRecord::Base
  belongs_to :participant
  belongs_to :image
end
