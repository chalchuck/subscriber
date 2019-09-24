PDFKit.configure do |config|
  config.default_options = {
    :encoding=>"UTF-8",
    :print_media_type => true,
    :page_size=>"Legal",
    :margin_right=>"0mm",
    :margin_bottom=>"0mm",
    :margin_left=>"0mm",
    :load_media_error_handling=> "ignore",
    :load_error_handling => "ignore",
    :disable_smart_shrinking=> false,
    :disable_javascript => true
  }
  # Use only if your external hostname is unavailable on the server.
  # config.root_url = "http://localhost"
end
