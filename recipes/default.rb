#
# Cookbook Name:: screen
# Recipe:: default
#
# Copyright 2013, shwada
#
# All rights reserved - Do Not Redistribute
#

src_path = "#{Chef::Config[:file_cache_path]}/screen"

git src_path do
  repository node.screen.repository
  reference  "master"
  revision   "master"
  user  "root"
  group "root"
  action :checkout
end

script "build screen" do
  interpreter "bash"
  user "root"
  cwd Chef::Config[:file_cache_path]

  opt = [
    "--prefix=#{node.screen.root}", 
    "--enable-colors256"
  ]

  code <<-EOH
  cd #{src_path}/src
  ./autogen.sh
  ./configure #{opt.join(' ')}
  make && make install
  EOH

  not_if do
    FileTest.directory? node.screen.root
  end
end
