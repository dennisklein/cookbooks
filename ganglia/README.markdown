# DESCRIPTION:

Compiles and installs Ganglia 1.3.7. Will compile and install RRDTools 1.4.4 
as a dependency too.

**NOTE**: This will compile gmetad and install dependencies for gmetad on all nodes, even if only
gmond is enabled. I will probably change this in a later version.

Ganglia default metrics will be enabled.

Ganglia allows many different setups. This cookbook supports the following setup:

"unicast non-tiered single-cluster"

       *------*
       |gmetad|   ...                  role "ganglia_collector"
       |gmond |  
       *------*----------*
         |  |            |
         |  *---*        |
         |      |        |
    *-----*  *-----*  *-----*
    |gmond|  |gmond|  |gmond|  ...     role "ganglia_agent"
    *-----*  *-----*  *-----*

Hosts with the role ganglia_agent will run a gmond which reports in unicast-mode
to all hosts with role ganglia_collector. Hosts with role ganglia_collector run
gmetad and gmond. The gmetad will poll the local gmond, but this can be overriden.
The gmond on the ganglia_collector node will function as the collector - it is the
only non-deaf gmond in this setup. 

There is no clean and nice support for a tiered gmetad and/or multi-cluster setup atm.
I will add this, if I need such a setup.

See ATTRIBUTES and USAGE for further details.

# REQUIREMENTS:

Operating Systems (I have tested on):

* Debian 5
* Scientific Linux 5.5

Should easily be adapted to other Red Hat and Debian based systems.

Dependencies (installed via OS package management by this cookbook):

* APR
* libconfuse
* Expat
* Python
* PCRE3
* Pango
* libxml2
* gcc
* make

# ATTRIBUTES: 

See example roles in roles/.

# USAGE:

Create roles "ganglia_collector" and "ganglia_agent". See roles/ for examples.
