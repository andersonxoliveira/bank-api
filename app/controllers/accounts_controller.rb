class AccountsController < ApplicationController
  before_action :set_account, only: %i[show update destroy]
  before_action :authenticate_user!, except: [:create]

  # GET api/v1/accounts
  def index
    @accounts = if params[:filter]
      Account.where(request.query_parameters[:filter])
    else
      Account.all
    end
    render json: AccountSerializer.new(@accounts).serializable_hash
  end

  # GET api/v1/accounts/1
  def show
    if @account.nil?
      render json: ErrorSerializer.serialize(@account.errors), status: :unprocessable_entity
    else
      render json: AccountSerializer.new(@account).serializable_hash
    end
  end

  # POST api/v1/accounts
  def create
    @account = Account.new(account_params)

    if @account.save
      render json: AccountSerializer.new(@account).serializable_hash, status: :created
    else
      render json: ErrorSerializer.serialize(@account.errors), status: :unprocessable_entity
    end
  end

  # PATCH/PUT api/v1/accounts/1
  def update
    if @account.update(account_params)
      render json: AccountSerializer.new(@account).serializable_hash
    else
      render json: ErrorSerializer.serialize(@account.errors), status: :unprocessable_entity
    end
  end

  # DELETE api/v1/accounts/1
  def destroy
    @account.destroy
  end

  private

  # def set_account
  #   @account = Account.find(params[:id])
  # end

  def account_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end