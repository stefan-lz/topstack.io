#some configuration options passed to TopStack::Serel (in lib)
Topstack::Application.config.serel_stackapps_type = :stackoverflow
Topstack::Application.config.serel_stackapps_api_key = Rails.application.secrets.stackapps_api_key
