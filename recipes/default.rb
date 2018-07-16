#
# Cookbook Name:: biodiv-ui
# Recipe:: default
#
# Copyright 2014, Strand Life Sciences
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "nodejs::nodejs_from_package"

biodivUiRepo = "#{Chef::Config[:file_cache_path]}/biodiv-ui"
additionalConfig = "#{node.biodivUi.extracted}/.env.kk"

bash 'cleanup extracted biodiv-ui' do
   code <<-EOH
   rm -rf #{node.biodivUi.extracted}
   rm -f #{additionalConfig}
   EOH
   action :nothing
   notifies :run, 'bash[unpack biodiv-ui]'
end

# download git repository zip
remote_file node.biodivUi.download do
  source   node.biodivUi.link
  mode     0644
  notifies :run, 'bash[cleanup extracted biodiv-ui]',:immediately
end

bash 'unpack biodiv-ui' do
  code <<-EOH
  cd "#{node.biodivUi.directory}"
  unzip  #{node.biodivUi.download}
  expectedFolderName=`basename #{node.biodivUi.extracted} | sed 's/.zip$//'`
  folderName=`basename #{node.biodivUi.download} | sed 's/.zip$//'`

  if [ "$folderName" != "$expectedFolderName" ]; then
      mv "$folderName" "$expectedFolderName"
  fi

  EOH
  not_if "test -d #{node.biodivUi.extracted}"
  notifies :create, "template[#{additionalConfig}]",:immediately
end


#  create additional-config
template additionalConfig do
  source "env.kk.erb"
  notifies :run, "npm_package[compile_biodiv-ui]", :immediately
end


npm_package "compile_biodiv-ui" do
  path "#{node.biodivUi.extracted}"
  json true
end

bash 'npm run build:kk' do
  code <<-EOH
  cd "#{node.biodivUi.extracted}"
  yes | npm run build:kk
  EOH
end
