class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transactions, only: %i[show update destroy]
  before_action :set_account, only: %i[create]

  # GET /transactions
  def index

    @transactions = if @user_type
      if params[:filter]
        Transaction.where(request.query_parameters[:filter])
      else
        Transaction.all
      end
    else
      if params[:filter]
        if params[:filter][:initial_date] && params[:filter][:end_date]
          filter = request.query_parameters[:filter]
          initial_date = DateTime.parse(filter[:initial_date]).beginning_of_day
          end_date = DateTime.parse(filter[:end_date]).end_of_day
          current_user.transactions.where('transactions.created_at BETWEEN ? AND ?', initial_date, end_date)
        else
          current_user.transactions.where(request.query_parameters[:filter])
        end
      else
        current_user.transactions
      end
    end

    render json: TransactionSerializer.new(@transactions).serializable_hash
  end

  # GET /transactions/1
  def show
    if @transaction.nil?
      render json: ErrorSerializer.serialize(@transaction.errors), status: :unprocessable_entity
    else
      render json: TransactionSerializer.new(@transaction).serializable_hash
    end
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params.merge(account_id: current_user.account_id))

    if !check_transaction
      render json: { message: "Usuário não possui saldo suficiente para operação!"}, status: :ok
    elsif @transaction.save
      score = if @transaction.transaction_type == "deposit"
        @account.score+@transaction.value
      elsif @transaction.transaction_type == "withdrawal"
        @account.score-@transaction.value
      else
        @transaction.destination_account.update(score: @transaction.destination_account.score+@transaction.value)
        @account.score-(@transaction.value+@rate)
      end

      if @account.update(score: score)
        render json: TransactionSerializer.new(@transaction).serializable_hash, status: :created
      else
        render json: ErrorSerializer.serialize(@transaction.errors), status: :unprocessable_entity
      end
    else
      render json: ErrorSerializer.serialize(@transaction.errors), status: :unprocessable_entity
    end
  end

  private

  def check_user_type
    @user_type = ([current_user.user_type] & ['admin', 'dba']).present? ? true : false
  end

  def set_rate
    if @transaction.transaction_type == "transfers_between_accounts"
      iti_week = DateTime.now.beginning_of_week + 8.hours
      end_week = (DateTime.now.end_of_week-2) - 6.hours
      now = DateTime.now
      rate = if now >= iti_week && now <= end_week
        5
      else
        7
      end
      if @transaction.value > 1000
        rate + 10
      else
        rate
      end
    else
      0
    end
  end

  def check_transaction
    @rate = set_rate
    if @transaction.transaction_type == "deposit" || (@account.score-(@transaction.value+@rate)) > 0
      true
    else
      false
    end
  end

  def set_account
    @account = current_user.account
  end

  def set_transactions
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end