#
# Cookbook Name:: crux
# Recipe:: crux
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

for i in node['crux']['ports']
dsc_script 'port' do
  code <<-EOH
    Script portconfiguration
          {
           SetScript = {
               New-NetFirewallRule -DisplayName "#{i.portname}" -Direction Inbound -LocalPort #{i.port} -Protocol TCP

            }
           TestScript = {
             $temp =Show-NetFirewallRule | Where-Object {$_.LocalPort -eq #{i.port}}
             if($temp -eq $null)
             {

               $false
             }
             else
             {
               $true
             }
            }
           GETScript = {
            }
          }
EOH
end
end

directory "#{node['crux']['directorypath']}" do
  recursive true
  action :delete
end

directory "#{node['crux']['directorypath']}" do
  action :create
end

remote_file "#{node['crux']['zippath']}" do
  source 'https://s3-ap-northeast-1.amazonaws.com/swamykonanki/SampleDemoPublish.zip'
  action :create
end

dsc_script 'Unzip' do
    code <<-EOH
      Archive Download {
        Ensure = "Present"
        Path = "#{node['crux']['zippath']}"
        Destination = "#{node['crux']['destinationpath']}"
      }
    EOH
  end





dsc_script 'apppool' do
  code <<-EOH
    Script 'apppoolcreation'
         {
           SetScript = {
             import-module webAdministration
             $apppool = new-item iis:\\AppPools\\"#{node['crux']['apppoolname']}"
             $apppool | set-itemproperty -name "manageruntimeversion" -value "#{node['crux']['dotnetversion']}"
                }
           TestScript = {
               import-module webAdministration
               if((Test-Path iis:\\AppPools\\"#{node['crux']['apppoolname']}" -pathType container))
               {
                $true}
               else{$false}
             }
           GetScript = {
             }
         }
EOH
end
dsc_script 'crux' do
  code <<-EOH
   Script 'cruxconfiguration'
      {
         SetScript = {
           import-module webAdministration
           $varible=New-Item IIS:\\Sites\\DemoSite -physicalPath c:\\crux\\SampleDemoPublish -bindings @{protocol="http";bindingInformation=":8081:"} -Force
           $varible | Set-ItemProperty IIS:\\Sites\\DemoSite -name applicationPool -value iis:\\AppPools\\"#{node['crux']['apppoolname']}"
           Start-webSite 'DemoSite'
          }
         TestScript = {
                   $false
          }
         GetScript = {
          }
      }
EOH
end
