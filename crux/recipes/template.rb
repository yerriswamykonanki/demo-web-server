#
# Cookbook Name:: crux
# Recipe:: template
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
template "C:\\crux\\SampleDemoPublish\\Web.config" do
  source "default.erb"
  variables({
      :ipaddress => node[:crux][:ip],
      :dbname => node[:crux][:dbname],
      :userid => node[:crux][:userid],
      :password => node[:crux][:password]
      })
end


# dsc_script 'sleep' do
# code <<-EOH
# Script 'sleepscript'
#    {          GetScript = {
#
#           }
#
#           SetScript = {
#               Start-Sleep -Seconds 700
#           }
#
#           TestScript = {
#               Return $false
#           }
#
#     }
#     EOH
#     end
    file "#{node['crux']['zippath']}" do
       action :delete
    end
