class MagazineController < ApplicationController
  before_action :magazine_address_confirm_params, only: [:confirm]
  before_action :magazine_address_update_confirm_params, only: [:confirm]
  before_action :magazine_address_create_params, only: [:create]

  def new
    @magazine_address = MagazineAddress.new
    @crud_patarn = 'create'
  end

  def confirm
    @crud_patarn = params[:crud_patarn]
    if @crud_patarn == 'create'
      @magazine_address = MagazineAddress.new(magazine_address_confirm_params)
      return if @magazine_address.valid?
      render :new
    elsif @crud_patarn == 'update'
      @magazine_address = MagazineAddress.new(magazine_address_update_confirm_params)
      return if @magazine_address.valid?
      render :edit
    end
  end

  def create
    MagazineAddress.create(magazine_address_create_params.merge(user_id: current_user.id))
    @pay_patarn = 'subscription'
    render 'payments/new_card'
  end

  def edit
    @magazine_address = MagazineAddress.find_by(user_id: current_user.id)
    @crud_patarn = 'update'
  end

  def update
    MagazineAddress.update(magazine_address_create_params.merge(user_id: current_user.id))
    render 'complete'
  end

  private

  def magazine_address_confirm_params
    params.require(:magazine_address).permit(:address, :zipcode, :building).merge(pref: params[:pref], city_address: params[:city_address])
  end

  def magazine_address_update_confirm_params
    params.require(:magazine_address).permit(:address, :zipcode, :building).merge(pref: params[:pref], city_address: params[:city_address], id: params[:id])
  end

  def magazine_address_create_params
    params.require(:magazine_address).permit(:address, :zipcode, :pref, :city_address, :building)
  end
end