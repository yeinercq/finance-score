class AccountsController < ApplicationController
  before_action :set_accout, only: [ :show, :edit, :update, :destroy ]

  def index
    @accounts = Account.all.ordered
  end

  def show
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to accounts_path, notice: "Account was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @account.update(account_params)
      redirect_to accounts_path, notice: "Account was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path, notice: "Account was successfully destroyed."
  end

  private

  def set_accout
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:number, :name, :nature, :account_type)
  end
end
