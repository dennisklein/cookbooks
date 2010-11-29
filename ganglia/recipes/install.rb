#
# Cookbook Name:: ganglia
# Recipe:: install
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

# install system dependencies
case node[:platform]
when "debian"
  packages = [ 'libapr1', 'libaprutil1-dev', 'libconfuse-dev', 'libexpat1-dev', 'python', 'libpcre3-dev', 'libpango1.0-dev', 'libxml2-dev', 'gcc', 'make']
when "scientific"
  packages = [ 'apr-devel', 'libconfuse-devel', 'expat-devel', 'python', 'pcre-devel', 'pango-devel', 'libxml2-devel', 'gcc', 'make' ]
else
  exit 1
end
packages.each { |p| package p } 

# compile and install RRDTool 1.4.4

# determine, if already installed ?
install = (!File.exists?("/opt/rrdtool-1.4.4")).to_s
log "RRDTool compile&install flag: " + install

cookbook_file "/tmp/rrdtool-1.4.4.tar.gz" do
  source "rrdtool-1.4.4.tar.gz"
  mode "0644"
  action :create_if_missing
  only_if install
end

script "compile and install RRDTool 1.4.4" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  only_if install
  code <<-EOSCRIPT
    export BUILD_DIR=/tmp/rrdbuild
    export INSTALL_DIR=/opt/rrdtool-1.4.4
    mkdir -p $BUILD_DIR
    cd $BUILD_DIR
    mv /tmp/rrdtool-1.4.4.tar.gz $BUILD_DIR
    tar -xzf rrdtool-1.4.4.tar.gz
    cd rrdtool-1.4.4
    ./configure --prefix=$INSTALL_DIR
    make
    make install
    #rm -r $BUILD_DIR
  EOSCRIPT
end

# compile and install Ganglia 3.1.7

# determine, if already installed ?       
install = (!File.exists?("/opt/ganglia-3.1.7")).to_s
log "Ganglia compile&install flag: " + install

cookbook_file "/tmp/ganglia-3.1.7.tar.gz" do
  source "ganglia-3.1.7.tar.gz"
  mode "0644"
  action :create_if_missing
  only_if install
end

script "compile and install Ganglia 3.1.7" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  only_if install
  code <<-EOSCRIPT
    export BUILD_DIR=/tmp/gangliabuild
    export INSTALL_DIR=/opt/ganglia-3.1.7
    export GANGLIA_ACK_SYSCONFDIR=1
    mkdir -p $BUILD_DIR
    cd $BUILD_DIR
    mv /tmp/ganglia-3.1.7.tar.gz $BUILD_DIR
    tar -xzf ganglia-3.1.7.tar.gz
    cd ganglia-3.1.7
    ./configure --prefix=$INSTALL_DIR --with-gmetad --with-librrd=/opt/rrdtool-1.4.4/
    make
    make install
    $INSTALL_DIR/sbin/gmond -t > $INSTALL_DIR/etc/gmond.conf
    #rm -r $BUILD_DIR
  EOSCRIPT
end

# create user ganglia which runs the daemons
user "ganglia" do
  comment "System user running the ganglia daemons"
  system true
  shell "/bin/false"
end

directory "/var/lib/ganglia/rrds" do
  owner "ganglia"
  mode "0755"
  recursive true
end
