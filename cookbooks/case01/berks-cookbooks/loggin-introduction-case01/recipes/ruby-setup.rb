ruby_build_ruby "ree-1.8.7-2012.02" do
  environment({ 'CONFIGURE_OPTS' => '--no-tcmalloc' })
end

ruby_build_ruby "1.9.1" do
  prefix_path "/usr/local/ruby/ruby-1.9.1"
  environment({
    'RUBY_BUILD_MIRROR_URL' => 'http://local.example.com'
  })

  action      :install
end
