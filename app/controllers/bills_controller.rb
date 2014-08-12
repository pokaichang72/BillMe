class BillsController < ApplicationController
  before_action :login_required
  before_action :set_bill, only: [:show, :edit, :update, :destroy]

  # GET /bills
  # GET /bills.json
  def index
    @bills = current_user.bills.all
    @charges = current_user.charges.all
  end

  # GET /bills/1
  # GET /bills/1.json
  def show
  end

  # GET /bills/new
  def new
    @bill = current_user.charges.new
    @graph = Koala::Facebook::API.new(current_user.fbtoken)
    @friends = @graph.get_connections("me", "friends")
  end

  # GET /bills/1/edit
  def edit
  end

  # POST /bills
  # POST /bills.json
  def create
    fail = false

    params['payers'].each do |payer_fbid|
      @payer = User.where({:fbid => payer_fbid}).first_or_create
      for i in 1..params['bill'].length
        @bill = current_user.charges.build(params.require('bill').require((i-1).to_s).permit(:name, :description, :unit_price, :quantity, :total_price))
        @bill.payer = @payer
        @bill.splits_to = params['total']['splits_to']
        if !@bill.save
          fail = true
        end
      end

      # params.require('bill').require('0').permit(:name, :description, :unit_price, :quantity, :total_price)
    end

    if fail
      flash[:alert] = '儲存失敗。'
      redirect_to new_bill_path
    else
      redirect_to root_path
    end


    # respond_to do |format|
    #   if @bill.save
    #     format.html { redirect_to @bill, notice: 'Bill was successfully created.' }
    #     format.json { render :show, status: :created, location: @bill }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @bill.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /bills/1
  # PATCH/PUT /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to @bill, notice: 'Bill was successfully updated.' }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy
    @bill.destroy
    respond_to do |format|
      format.html { redirect_to bills_url, notice: 'Bill was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bill_params
      params.require(:bill).permit(:name, :description, :unit_price, :quantity, :total_price)
    end
end
