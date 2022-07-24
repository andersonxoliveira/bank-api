class AccountsController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  before_action :set_account, only: %i[update, disable]
  before_action :check_user_type, only: %i[show update index]

  # GET /accounts
  def index
    @accounts = if @user_type
      if params[:filter]
        Account.where(request.query_parameters[:filter])
      else
        Account.all
      end
    else
      current_user.account
    end
    render json: AccountSerializer.new(@accounts).serializable_hash
  end

  # GET /accounts/1
  def show
    if @account.nil?
      render json: ErrorSerializer.serialize(@account.errors), status: :unprocessable_entity
    else
      render json: AccountSerializer.new(@account).serializable_hash
    end
  end

  # POST /accounts
  def create
    @account = Account.new(account_params)

    if @account.save
      render json: AccountSerializer.new(@account).serializable_hash, status: :created
    else
      render json: ErrorSerializer.serialize(@account.errors), status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounts/1
  def update
    if @user_type
      if @account.update(account_params)
        render json: AccountSerializer.new(@account).serializable_hash
      else
        render json: ErrorSerializer.serialize(@account.errors), status: :unprocessable_entity
      end
    else
      render json: {message: 'Usuáro não tem premissão para esse recurso!'}, status: :ok
    end
  end

  def disable
    if @account.update(status: :disabled)
      render json: {message: 'Conta desativada com sucesso!'}, status: :ok
    else
      render json: ErrorSerializer.serialize(@account.errors), status: :unprocessable_entity
    end
  end

  private

  def check_user_type
    @user_type = ([current_user.user_type] & ['admin', 'dba']).present? ? true : false
  end

  def set_account
    @account = current_user.account
  end

  def account_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end