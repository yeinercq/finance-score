class AccountsController < ApplicationController
  before_action :set_accout, only: [ :show, :edit, :update, :destroy ]
  before_action :set_mayor_account, only: [ :create ]

  def index
    @accounts = Account.all.ordered
  end

  def show
  end

  def new
    @account = Account.new
  end

  def create
    if @mayor_account.present?
      @account = @mayor_account.mayoriced_accounts.build(account_params)
    else
      @account = Account.new(account_params)
    end

    if @account.save
      respond_to do |format|
        format.html { redirect_to accounts_path, notice: "Account was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Account was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @account.update(account_params)
      respond_to do |format|
        format.html { redirect_to accounts_path, notice: "Account was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Account was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_path, notice: "Account was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Account was successfully destroyed." }
    end
  rescue ActiveRecord::InvalidForeignKey
    respond_to do |format|
      format.html { redirect_to accounts_path, notice: "Cannot destroy account because it has dependent records." }
      format.turbo_stream do
        flash.now[:alert] = "Cannot destroy account because it has dependent records."
        render turbo_stream: turbo_stream.prepend("flash", partial: "layouts/flash")
      end
    end
  end

  private

  def set_accout
    @account = Account.find(params[:id])
  end

  def set_mayor_account
    mayor_account_length = Account.get_account_length(Account.get_account_level(account_params[:number]) - 1)
    mayor_account_number = account_params[:number].to_s[0..mayor_account_length - 1].to_i
    @mayor_account = Account.find_by(number: mayor_account_number, account_type: 1)
  end

  def account_params
    params.require(:account).permit(:number, :name, :nature, :account_type)
  end
end
