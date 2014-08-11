class Setting < Settingslogic

  if File.file?("#{Rails.root.to_s}/config/configuration.yml")
    source "#{Rails.root.to_s}/config/configuration.yml"
  else
    source "#{Rails.root.to_s}/config/configuration.yml.example"
  end

  namespace Rails.env
end
