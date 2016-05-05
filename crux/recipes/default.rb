#
# Cookbook Name:: crux
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'crux::iis'
include_recipe 'crux::web'
# include_recipe 'crux::user'
include_recipe 'crux::template'
