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
  scope :ordered, -> { order("id ASC") }

  validates :number, :name, :account_type, :nature, presence: true
  validates :number, uniqueness: true, comparison: { greater_than: 0 }
  validates :name, uniqueness: { case_sensitive: false }
  validate :correct_caracter_number, if: :not_level_1?

  before_create :squish_name, :set_account_level
  before_create :create_mayor_account, if: :is_movement_account?

  belongs_to :mayor_account, class_name: "Account", foreign_key: "mayor_account_id", optional: true
  has_many :mayoriced_accounts, class_name: "Account", foreign_key: "mayor_account_id"

  enum :nature, { debit: 1, credit: 2 }
  enum :account_type, { mayor: 1, movement: 2 }

  # Validations
  #
  def is_movement_account?
    account_type == "movement"
  end

  def not_level_1?
    Account.get_account_level(number) > 1
  end

  # Callbacks actions
  #
  def create_mayor_account
    CreateMayorAccountService.call(self)
  end

  def squish_name
    self.name = name.squish
  end

  def set_account_level
    self.level ||= Account.get_account_level(number)
  end

  # V
  #
  def correct_caracter_number
    unless number.to_s.length % 2 == 0
      errors.add(:number, "number of caracters must be a multiple of 2")
    end
  end

  # Class methods
  #
  def self.get_account_level(account_number)
    return 1 if account_number.to_s.length == 1
    (account_number.to_s.length / 2) + 1
  end

  def self.get_account_length(account_level)
    return 1 if account_level == 1
    (account_level - 1) * 2
  end
end
