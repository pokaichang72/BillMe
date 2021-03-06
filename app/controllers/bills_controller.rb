class BillsController < ApplicationController
  before_action :login_required
  before_action :set_bill, only: [:show, :edit, :update, :destroy]

  # GET /bills
  # GET /bills.json
  def index
    @bills = current_user.bills.all
    @charges = current_user.charges.all
    @debtors = current_user.debtors.all  # 欠我錢的
    @creditors = current_user.creditors.all  # 我欠錢的
    @recent_debtors = current_user.recent_debtors.all  # 欠我錢的
    @recent_creditors = current_user.recent_creditors.all  # 我欠錢的
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
    @bills = []
    @payers = []
    @bills_total = params['total']
    pc = 0

    if params['cancel'] == 'true'
      params['bills'].each do |b_id|
        current_user.charges.find(b_id).delete
      end
    else

      params['payers'].each do |payer_fbid|
        pc += 1
        @payer = User.where({:fbid => payer_fbid}).first_or_create! do |user|
          user.email = Devise.friendly_token[0,20] + '@facebook.com'
          user.password = Devise.friendly_token[0,20]
        end
        @payers << @payer
        for i in 1..params['bill'].length
          @bill = current_user.charges.build(params.require('bill').require((i-1).to_s).permit(:name, :description, :unit_price, :quantity, :total_price))
          @bill.payer = @payer
          @bill.state = "New"
          @bill.splits_to = params['total']['splits_to']
          if !@bill.save
            fail = true
          end
          @bills << @bill
        end

        # params.require('bill').require('0').permit(:name, :description, :unit_price, :quantity, :total_price)
        @crb = current_user.charges.new
      end
    end

    if fail
      flash[:alert] = '儲存失敗。'
      redirect_to new_bill_path
    elsif params['cancel'] == 'true'
      flash[:success] = '已撤銷。'
      redirect_to bills_path
    else
      flash[:success] = '已簽發。'
      render :create_success
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

  def update_state
    if params.has_key?("multiple")
      bill_ids = params['bill_ids'].split(',')
    else
      bill_ids = [params['bill_id']]
    end

    has_failed = false
    bill_ids.each do |bill_id|
      bill = Bill.find(bill_id)
      case params['state']
      when 'Canceled'
        if bill.payee == current_user && bill.state != 'Canceled' && bill.state != 'Paid?' && bill.state != 'Paid'
          bill.state = 'Canceled'
          bill.save
          flash[:success] = '撤銷成功。'
        else
          has_failed = true
        end
      when 'Paid'
        if bill.payee == current_user && bill.state != 'Canceled'
          bill.state = 'Paid'
          bill.save
          flash[:success] = '已確認付款。'
        else
          has_failed = true
        end
      when 'Accepted'
        if bill.payer == current_user && bill.state != 'Canceled' && bill.state != 'Paid' && bill.state != 'Paid?'
          bill.state = 'Accepted'
          bill.save
          flash[:success] = '已承諾付款。'
        else
          has_failed = true
        end
      when 'Paid?'
        if bill.payer == current_user && bill.state != 'Canceled'
          bill.state = 'Paid?'
          bill.save
          flash[:success] = '已回報付款。'
        else
          has_failed = true
        end
      when 'Dispute'
        if bill.payer == current_user && bill.state != 'Dispute' && bill.state != 'Accepted' && bill.state != 'Canceled' && bill.state != 'Paid?' && bill.state != 'Paid'
          bill.state = 'Dispute'
          bill.save
          flash[:success] = '已標示為異議。'
        else
          has_failed = true
        end
      end
    end

    if has_failed
      flash[:alert] = '並非所有操作都能被執行。'
    end

    redirect_to root_path
  end

  def my_bills
    @my_bills = current_user.bills
    render 'my_bills'
  end

  def my_charges
    @my_charges = current_user.charges
    render 'my_charges'
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
