# example
name "ganglia_collector"
description "Tier 1 collector node for Ganglia cluster."
run_list "recipe[ganglia]"

default_attributes :ganglia => { 
:gmetad => {
  :enabled => true,                  # Enable gmetad
  :gridname => "Pick a name" },      # Set your grid name
:gmond => { 
  :cluster => { :name => "Pick a name" }}} # Set cluster name this collector belongs to 
