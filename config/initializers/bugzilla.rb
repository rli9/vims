BUGZILLA_CONFIG = YAML.load_file("#{Rails.root}/config/bugzilla.yml")[Rails.env]