class ItemsController < ApplicationController
  def index
    @items = Item.includes(:images)
  end

  def show
    @item = Item.find(params[:id])
    # 詳細表示機能イメージ表示用
    # @image = Image.where(@item)
    status = Status.find(@item.status_id)
    shipping_charges = ShippingCharges.find(@item.shipping_charges_id)
    prefecture = Prefecture.find(@item.prefecture_id)
    category = Category.find(@item.category_id)
    shipping_days = ShippingDays.find(@item.shipping_days_id)
  end

  def new
    @item = Item.new
    @item.images.new
    @category_parent_array = ["選択してください"]
    #データベースから、親カテゴリーのみ抽出し、配列化
      Category.where(ancestry: nil).each do |parent|
        @category_parent_array << parent.name
      end
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to items_path
    else
      redirect_to new_item_path
    end
  end

  def search_child  
    @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
  end

  def search_grandchild
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  private
  def item_params
    params.require(:item).permit(:name, :discription, :status_id, :shipping_charges_id, :shipping_days_id, :price, :size_id, :brand_id, :prefecture_id, :category_id, images_attributes: [:image])
  end

  
end
