class Api::V1::VisitRecordsController < ApplicationController
  # before_action :authenticate_user!


  def index
    # VisitRecordテーブル内のデータをdateの降順に並べて取得
    visit_records = VisitRecord.order(date: :desc)
    render json: visit_records
  end

  def create
    visit_record_params[:user_id] =  nil if visit_record_params[:user_id].blank?

    visit_record = VisitRecord.new(visit_record_params)
    
    if visit_record.save
      render json: visit_record, status: :created
    else
      render json: { errors: visit_record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create_from_form
    store = Store.find_by(store_name: params[:store_name])
    user = User.find_by(nickname: params[:user_name])

  
    if store.nil?
      return render json: { message: "指定された店舗が見つかりません" }, status: :unprocessable_entity
    end
  
    if user.nil?
      return render json: { message: "指定されたユーザーが見つかりません" }, status: :unprocessable_entity
    end

    visit_record = VisitRecord.new(
      date: params[:date],
      store_id: store.id, # store_id を取得
      user_id: user.id,
      memo: params[:memo],
      price: params[:price]
    )
  
    if visit_record.save
      render json: visit_record, status: :created
    else
      render json: { message: "訪問記録の作成に失敗しました", errors: visit_record.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  def destroy
    visit_record = VisitRecord.find(params[:id])
    visit_record.destroy
  
    render json: { message: '訪問記録が削除されました' }, status: :ok
    head :ok
  end

  def update
    visit_record = VisitRecord.find(params[:id])

    if visit_record.update(visit_record_params)
      render json: { message: "訪問記録が正常に更新されました", visit_record: visit_record }, status: :ok
    else
      render json: { message: "訪問記録の更新に失敗しました", errors: visit_record.errors }, status: :unprocessable_entity
    end
  end

  
  def plot_stores
    visit_records = VisitRecord
    .joins(:store)
    .left_joins(:user)#user_id: nil でもデータが取得される
    .select('visit_records.*, stores.id AS store_id, stores.store_name, stores.latitude, stores.longitude, users.id AS user_id, users.nickname')
    .order(date: :desc)

    grouped_data = visit_records.group_by(&:store_id).map.with_index do |(store_id, records), index|
      {
        store_id: store_id.to_s,
        store_name: records.first.store_name,
        latitude: records.first.latitude,
        longitude: records.first.longitude,
        last_date: records.first.date, # 最新の訪問日 datetime型
        count: records.count.to_s, # 訪問回数
        visit_records: records.map do |record|
        {
          date: record.date, # `date` のみ
          memo: record.memo,
          user_id: record.user_id, # `users.id` を `user_id` として取得
          user_name: record.user&.nickname || "ゲスト", # `nil` の場合は "ゲスト" にする
        }
        end
      }
    end
    render json: grouped_data, status: :ok, content_type: "application/json"
  end

  # 専用メソッド: visit_records_with_store
  def with_store
    visit_records = VisitRecord.includes(:store, :user).all.order(date: :desc)

    render json: visit_records.map { |record|
      {
        id: record.id,
        store_id: record.store.id,
        store_name: record.store.store_name,
        user_id: record.user_id,
        user_name: record.user&.nickname || "ゲスト",
        date: record.date,
        memo: record.memo
      }
    }
  end

  def bulk_create
    visit_records = params[:_json].map do |record|
      VisitRecord.new(date: record[:date], store_id: record[:store_id], memo: record[:memo])
    end

    if VisitRecord.import(visit_records) # 高速バルクインサート
      render json: { message: "店舗データを一括登録しました" }, status: :created
    else
      render json: { message: "店舗データの登録に失敗しました" }, status: :unprocessable_entity
    end
  end

  private
  def visit_record_params
    params.require(:visit_record).permit(:date, :store_id, :memo, :user_id)
  end
end
