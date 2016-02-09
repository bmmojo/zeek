# Load the core cluster support.
@load ./main

@if ( Cluster::is_enabled() )

# Give the node being started up it's peer name.
redef peer_description = Cluster::node;

# Add a cluster prefix.
@prefixes += cluster

# If this script isn't found anywhere, the cluster bombs out.
# Loading the cluster framework requires that a script by this name exists
# somewhere in the BROPATH.  The only thing in the file should be the
# cluster definition in the :bro:id:`Cluster::nodes` variable.
@load cluster-layout

@if ( Cluster::node in Cluster::nodes )

@load ./setup-connections

# Don't load the listening script until we're a bit more sure that the
# cluster framework is actually being enabled.
@load policy/frameworks/broker/listen

## Set the port that this node is supposed to listen on.
redef Broker::listen_port = Cluster::nodes[Cluster::node]$p;
#redef Broker::listen_interface = Cluster::nodes[Cluster::node]$ip;

@if ( Cluster::has_local_role(Cluster::MANAGER) )
@load ./nodes/manager
@endif

@if ( Cluster::has_local_role(Cluster::DATANODE) )
@load ./nodes/datanode
@endif

@if ( Cluster::has_local_role(Cluster::WORKER) )
@load ./nodes/worker
@endif

@endif
@endif
