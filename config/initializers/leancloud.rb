require 'leancloud-ruby-client'

AV.init(application_id:  Rails.application.secrets.leancloud_id, master_key:  Rails.application.secrets.leancloud_master_key, quiet: true)
