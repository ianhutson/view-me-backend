class User < ApplicationRecord
    has_many :bids
    has_many :auctions, through: :bids
end
