class Api::V1::StoresController < ApplicationController
  
  def index
    stores = Store.order(created_at: :desc) # ✅ `created_at` の降順に並べる
    render json: stores
  end

  def index_1
    query = params[:query]
    if query.present?
      stores = Store.where("store_name LIKE ?", "%#{query}%").limit(10) # 🔥 修正
    else
      stores = Store.limit(10) # 🔥 クエリがない場合は適当なデータを返す
    end
    render json: stores
  end
  

  def nearby
    latitude = params[:latitude].is_a?(String) ? params[:latitude].to_f : params.dig(:latitude, :latitude).to_f
    longitude = params[:longitude].is_a?(String) ? params[:longitude].to_f : params.dig(:latitude, :longitude).to_f

    Rails.logger.debug "latitude: #{latitude}" # リクエストパラメータ全体を確認
    Rails.logger.debug "longitude: #{longitude}" # 強制パラメータ後の確認

    nearby_stores = Store.near([latitude, longitude], 10) # 2km 以内の店舗を取得
    render json: nearby_stores
  end

  def create
    store = Store.new(store_params)
    if store.save
      render json: store, status: :created
    else
      render json: { errors: store.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    store = Store.find(params[:id])
    store.destroy
  
    render json: { message: '店舗データが削除されました' }, status: :ok
    # head :ok
  end

  def update
    store = Store.find(params[:id])

    if store.update(store_params)
      render json: { message: "店舗データが正常に更新されました", store: store }, status: :ok
    else
      render json: { message: "店舗データの更新に失敗しました", errors: store.errors }, status: :unprocessable_entity
    end
  end

  # 一括生成
  def bulk_create
    stores = params[:_json].map do |store|
      Store.new(store_name: store[:store_name], latitude: store[:latitude], longitude: store[:longitude])
    end

    if Store.import(stores) # 高速バルクインサート
      render json: { message: "店舗データを一括登録しました" }, status: :created
    else
      render json: { message: "店舗データの登録に失敗しました" }, status: :unprocessable_entity
    end
  end



  private

  def store_params
    params.require(:store).permit(:store_name, :latitude, :longitude)
  end
end
