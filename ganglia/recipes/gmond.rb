#
# Cookbook Name:: ganglia
# Recipe:: gmond
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
cookbook_file "/etc/init.d/gmond" do
  source "#{node[:platform]}_gmond"
  mode "0777"
end

# search ganglia_collectors and configure node
udp_send_channels = Array.new
search(:node, "role:ganglia_collector") do |collector| 
  udp_send_channels << { :host => collector[:fqdn] }
end
udp_send_channels.uniq!
log "Ganglia udp_send_channels: #{udp_send_channels.inspect}"
node[:ganglia][:gmond][:udp_send_channel] = udp_send_channels

unless udp_send_channels.empty? then
  # generate gmond config file and restart gmond
  template "/opt/ganglia-3.1.7/etc/gmond.conf" do
    source "gmond.conf.erb"
    notifies :restart, "service[gmond]"
  end
else
  log "Shutting down gmond, because no ganglia_collector was found to report to." do
    notifies :stop, "service[gmond]"
  end
end

service "gmond" do
  supports :restart => true, :status => true
  action :enable      
end  
