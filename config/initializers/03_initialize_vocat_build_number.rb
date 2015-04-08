
build = nil
if Rails.env.development?
  output = `git describe --always --tags`
  build = output.strip
else
  path = Rails.root.join('public', 'revision.txt')
  if File.exists?(path)
    build = File.read(path).strip
  end
end

Vocat::Application.configure do
  config.vocat_build_number = build
end
