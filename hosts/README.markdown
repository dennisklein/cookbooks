# DESCRIPTION:

Generates /etc/hosts from all nodes known by chef. Enables hostname resolving
between your chef-managed nodes without external DNS.

# TODO:

 * Configure node search query through attribute
 * Add IPv6 support 

# USAGE:

recipe[hosts]

NOTE: Due to the nature of chef's node discovery, the generated /etc/hosts
will only contain nodes already discovered by chef. If you batch-discover
many nodes for the first time, the expected /etc/hosts will be most likely
generated on the second chef-client run.
