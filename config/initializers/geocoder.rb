Geocoder.configure(
  lookup: :nominatim,  # 無料の地理データAPI (Google API も可)
  timeout: 5,          # APIのタイムアウト時間（秒）
  units: :km           # 距離を km 単位で計算
)