#
# Cookbook:: segulja_spacewalk
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

remote_file '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT' do
  source node['segulja_spacewalk']['spacewalk_org_trusted_ssl_cert']
  action :create
end

execute 'Register with the Spacewalk Server' do
  command <<-EOC
    rhnreg_ks --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT \\
        --serverUrl=http://spacewalk.segulja.com/XMLRPC \\
        --activationkey=1-oraclelinux7-x86_64
    EOC
  action :run
  not_if { ::File.exist?('/etc/sysconfig/rhn/systemid') }
end

%w(rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin osad).each do |pkg|
  package pkg do
    action :install
  end
end
