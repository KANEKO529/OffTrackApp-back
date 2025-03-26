class Api::V1::PurchasesController < ApplicationController
  # require "google_drive"
  
  require "google/apis/sheets_v4"

  def record_purchase_ledger
    service = Google::Apis::SheetsV4::SheetsService.new
    # json_key_io = File.open(Rails.root.join(ENV["GOOGLE_SERVICE_ACCOUNT_JSON"]))
    json_key_io = File.open(Rails.root.join("config/google-service-account.json"))

    service.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: json_key_io,
      scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS
    )

    # spreadsheet_id = ENV["SPREADSHEET_ID"]
    spreadsheet_id = '1eHlGwMernEe9Un_AZBbGyCh73JXYIKybFo_CN4HZJSo'

    sheet_name = "New仕入れ台帳"

    purchase_data = params.require(:purchase).permit(:date, :store_name, :price, :memo, :latitude, :longitude)

    formatted_date = DateTime.parse(purchase_data[:date]).in_time_zone("Asia/Tokyo").strftime("%Y/%m/%d %H:%M:%S")

    new_row_values = [
      formatted_date,
      purchase_data[:store_name],
      purchase_data[:price],
      purchase_data[:memo],
      purchase_data[:latitude],
      purchase_data[:longitude]
    ]

    # スプレッドシートにデータを追加
    value_range_object = Google::Apis::SheetsV4::ValueRange.new(
      values: [new_row_values]
    )
    range = "#{sheet_name}!A:A"

    service.append_spreadsheet_value(
      spreadsheet_id,
      range,
      value_range_object,
      value_input_option: "RAW"
    )

    render json: { message: "仕入れ台帳に追加しました！" }, status: :created
  end
end
