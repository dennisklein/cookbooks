#
# Cookbook Name:: ganglia
# Recipe:: gmetad
#
# Copyright 2010 Dennis Klein <d.klein@gsi.de>
# Copyright 2010 GSI Helmholtzzentrum fuer Schwerionenforschung GmbH 
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

# install init.d startup script
cookbook_file "/etc/init.d/gmetad" do
  source "#{node[:platform]}_gmetad"
  mode "0777"
end

# search ganglia clusters
clusters = Array.new
search(:node, "role:ganglia_agent") do |agent|
  clusters << agent[:ganglia][:gmond][:cluster][:name]
end
clusters << node[:ganglia][:gmond][:cluster][:name]
log "Ganglia clusters: #{clusters.uniq}"
  
data_sources = Array.new
clusters.uniq.each do |name|
  data_sources << { :cluster => name }
end

log "Ganglia data_sources: #{data_sources.inspect}"
node[:ganglia][:gmetad][:data_source] = data_sources

# generate gmetad config file
template "/opt/ganglia-3.1.7/etc/gmetad.conf" do
  source "gmetad.conf.erb"
  notifies :restart, "service[gmond]"
end

service "gmetad" do
  supports :restart => true, :status => true 
  action [ :enable, :start ]
end  

