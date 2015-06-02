# When installing new rubies, install guard and guard-livereload:
# gem install guard
# gem install guard-livereload
guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim)})
  watch(%r{build/.+\.(html)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  watch(%r{spec/javascripts/.+\.(js|erb|coffee)})
  watch(%r{build/assets/.+\.(js|css)})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|less))).*}) { |m| "/assets/#{m[3]}" }
end
