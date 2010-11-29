# example
name "ganglia_agent"
description "Pure agent node in a Ganglia cluster"
run_list "recipe[ganglia]"

default_attributes :ganglia => { :gmond => { :cluster => { :name => "Pick a name" }}} # Set cluster name this agent belongs to
