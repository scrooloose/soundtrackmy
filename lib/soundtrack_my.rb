require "rubygems"
require "bundler/setup"

require 'json'
require 'httparty'
require 'cgi'

lib_dir = File.dirname(__FILE__) + "/soundtrack_my"
require "#{lib_dir}/map_my_run_route_api_call"
require "#{lib_dir}/route"
require "#{lib_dir}/google_maps_elevation_api_call"
require "#{lib_dir}/gps_reading"
require "#{lib_dir}/marker"
require "#{lib_dir}/speed_calculator"
require "#{lib_dir}/zone_calculator"
require "#{lib_dir}/data_thinner"
