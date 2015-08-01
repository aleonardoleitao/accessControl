#TODO tests!
def symbolize_keys_recursively(h)
  case h
  when Hash
    Hash[
      h.map do |k, v|
        [ k.respond_to?(:to_sym) ? k.to_sym : k, symbolize_keys_recursively(v) ]
      end
    ]
  when Enumerable
    h.map { |v| symbolize_keys_recursively(v) }
  else
    h
  end
end

PAPERCLIP_CONFIG = symbolize_keys_recursively(YAML.load(ERB.new(File.read(Rails.root.join('config', 'paperclip.yml'))).result(binding)))
