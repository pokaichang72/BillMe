SeoHelper.configure do |config|
  config.skip_blank               = false
  config.site_name                = Setting.app_name
  config.default_page_description = Setting.app_description
  config.default_page_keywords    = Setting.app_keywords
  config.site_name_formatter      = lambda { |title, site_name|   "#{title} - #{site_name}" }
end
