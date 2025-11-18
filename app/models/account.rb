class Account < ApplicationRecord
  validates :number, :name, :type, :nature, presence: true
  validates :number, uniqueness: true
  validates :name, uniqueness: { case_sensitive: false }

  enum nature: { debit: 1, credit: 2 }
  enum type: { mayor: 1, movement: 2 }
end
