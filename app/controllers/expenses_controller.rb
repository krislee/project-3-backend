class ExpensesController < ApplicationController
  before_action :authorized

  def index
    @expenses = Expense.where({budget: params[:budget_id]})
    render json: {
        'response': "Here are all your expenses",
        :data => @expenses
    }
  end

  def create
    @one_expense = Expense.new(expense_params)
    if @one_expense.save
      render :json => {
          :response => 'successfully added new expense',
          :data => @one_expense
      }
    else
      render :json => {
          :error => 'not a valid expense'
      }
    end
  end

  def show
    @single_expense = Expense.exists?(params[:id])
    if @single_expense
      render :json => {
          :response => 'expense found',
          :data => Expense.find(params[:id])
      }
    else
      render :json => {
          :response => 'expense not found'
      }
    end
  end

  def update
    if(@single_expense_update = Expense.find_by_id(params[:id])).present?
      @single_expense_update.update(expense_params)
      render :json => {
          :response => 'successfully updated your expenses',
          :data => @single_expense_update
      }
    else
      render :json => {
          :response => 'update failure'
      }
    end
  end

  def destroy
    if(@delete_expense = Expense.find_by_id(params[:id])).present?
      @delete_expense.destroy
      render :json => {
          :response => 'Successfully destroyed'
      }
    else
      render :json => {
          :response => 'Nothing to destroy, shall I destroy you instead?'
      }
    end
  end

  private

  def expense_params
    params.permit(:id, :amount, :category, :date, :budget_id)
  end

end
