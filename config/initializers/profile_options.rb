PROFILE_OPTIONS = HashWithIndifferentAccess.new(YAML.load(ERB.new(File.read(Rails.root.join('config', 'profile_options.yml'))).result(binding)))
#STATES_AND_CITIES = JSON.parse(ERB.new(File.read(Rails.root.join('app/assets/javascripts/states_cities.json'))).result(binding))
