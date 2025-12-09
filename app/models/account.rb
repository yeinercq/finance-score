# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  number       :integer
#  name         :string
#  nature       :integer
#  account_type :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Account < ApplicationRecord
  validates :number, :name, :account_type, :nature, presence: true
  validates :number, uniqueness: true
  validates :name, uniqueness: { case_sensitive: false }

  enum :nature, { debit: 1, credit: 2 }
  enum :account_type, { mayor: 1, movement: 2 }
end
