class CreateMayorAccountService
  def self.call(accout)
    new(accout).call
  end

  def initialize(account)
    @account = account
  end

  def call
    account_level = get_account_level(@account.number)
    levels = []

    while account_level >= 1
      account_level -= 1
      levels << account_level unless account_level == 0
    end

    name_base = @account.name.squish
    mayor_account_params_base = {
      nature: @account.nature,
      account_type: 1
    }

    levels.reverse.each do |level|
      account_length = get_account_length(level)
      number = @account.number.to_s[0..account_length - 1].to_i

      if Account.exists?(number: number, account_type: 1)
        next
      else
        params = mayor_account_params_base.merge({
          name: "#{name_base} level #{level}",
          number: number,
          level: level
        })
        if level == 1
          Account.create!(params)
        else
          mayor_account_length = get_account_length(level - 1)
          mayor_account = Account.find_by(number: number.to_s[0..mayor_account_length - 1].to_i, account_type: 1)
          mayor_account.mayoriced_accounts.create!(params)
        end
      end
    end
  end

  def get_account_level(account_number)
    Account.get_account_level(account_number)
  end

  def get_account_length(account_level)
    Account.get_account_length(account_level)
  end
end
