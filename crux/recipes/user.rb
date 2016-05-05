#
# Cookbook Name:: crux
# Recipe:: user
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
# Cookbook Name:: crux
# Recipe:: user
#
# Copyright (c) 2016 The Authors, All Rights Reserved.



dsc_script 'user' do
  code <<-EOH
    Script changeadminname
    {
      SetScript = {
        $user = Get-WMIObject Win32_UserAccount -Filter "Name='#{node['crux']['oldname']}'"
        $result = $user.Rename(#{node['crux']['newname']})
        $user = [ADSI]"WinNT://./#{node['crux']['newname']},user"
        $user.SetPassword(#{node['crux']['password']})
        }
      TestScript = {
        $user = Get-WMIObject Win32_UserAccount -Filter "Name='#{node['crux']['oldname']}'"
        if($user -eq $null)
        {
         "entered user is not existed."
         $true
        }
        else
        {

          if(#{node['crux']['newname']} -eq $user)
           {
             "entered name is same as administrator name."
              $true
           }
          else
          {
            $false
          }
        }
            }
       GetScript = {
            }
    }
    Scriptchangemachinename
    {
     SetScript = {
        Rename-Computer -NewName #{node['crux']['computername']}
        "computer name is changed successfully."
       }
     TestScript = {

       $var=$env:COMPUTERNAME
       if($var -eq #{node['crux']['computername']})
       {
         "computer name is same as u entered name"
          $true
       }
       else
       {
         $false
       }
      }
     GetScript = {
       }
    }
  EOH
end
