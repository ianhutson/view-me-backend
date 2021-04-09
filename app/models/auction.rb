class Auction < ApplicationRecord
    has_many :users, through: :bids
    has_many :bids
  end
