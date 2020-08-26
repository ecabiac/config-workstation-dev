# Workstation Docker Swarm Setup

## Machine Setup

My local workstation is configured as a single-node docker swarm using [Docker Desktop](https://docs.docker.com/docker-for-windows/install/). This setup assumes that only linux containers are being run. I am not running any windows containers, nor do I know how to run windows and linux containers side-by-side on the same nworkstation. I currently do not have WSL2.

Docker Swarm supports the ability to specify that service instances should be evenly spread across multiple zones. Although this is completely useless in a single-node swarm, for the purposes of indicating how this might be used I have defined a single-zone scheme `zones_x1` with a single member of `A`. I assign my single-node to this zone by assigning the label `zones_x1=A` to my swarm node. If you had three nodes, you could use a similar convention and assign labels like `zones_x3=A`, `zones_x3=B`, and `zones_x3=C`. The zones can be utilized for a swarm service by specifying a "spread" placement preference with your scheme like:
```yaml
      placement:
        preferences:
          - spread: node.labels.zones_x1
```

## Swarm Setup

### Swarm Networks
My docker swarm instance is explicitly configured with 2 bridge networks. Individual stacks may define their own networks, which should only be used by services within the respective stack. Even 2 networks for a local setup might be overkill, you might be able to get away with a single network (and I am considering such an approach for myself)

  - `edge-overlay`: Services attached to this network when they should be directly reachable from the host machine (i.e. via a browser). Note that since this is a developer setup, there may be services (including APIs, Message Queues, Databases) which would not be externally available in a true server setup, but are placed on this network to make development easier.
  - `mesh-overlay`: A common network to which all services may be attached. When services communicate across stacks, it should be done over this network.

### Essential and Shared Stacks

  - `edge`: This stack runs an instance of [Traefik](https://docs.traefik.io/), an edge router, load balancer, and reverse proxy. Our AWS and Azure environments each run a Load Balancer / Reverse Proxy solution that is custom to the cloud provider. You won't be able to effectively simulate this setup without a tool like Traefik.
  - `shared_sql`: As a pure consideration of size and performance, I run a single
  containerized instance of SQL Server and host all of my local SQL Server databases there. In general, we want to aim for more of a microservice approach in which any stack with a SQL Server dependency would run its own SQL Server instance, but it is just too taxing to do so on a single-node workstation. If you are willing to handle the networking, you can just run a local instance of SQL Server without using docker.
  - `mail`: This **optional** stack runs a simple service which exposes an SMTP protocol but doesn't actually route mail through mail servers. Instead, it stores them all in a local database and the developer can view the messages via a web interface.
  - `metrics`: This **optional** stack runs prometheus and graphana which are used to collect and display running metrics. There are sdome built-in integrations for Kong and Traefik, but mostly I just run this out of personal interest. Sometimes I remove this stack to free up resources on my machine.

### Other Stacks

- I run `consul` and `keycloak` stacks just for reference. They is no dependency on them by other parts of the system.
- There are a few stacks for technologies like `rabbitmq`, `kafka`, `mongodb`, `redis`, etc. Most of the time I am not running these on my machine. Whenever I run stacks on Docker Swarm, I always place the definitions in this repository, even if they are just for experimental or learning purposes. In most cases, when a subsystem does make use of these technologies, instances should be run in the appropriate stack, even if that means having multiple instances of a particular technology. Keeping systems as decoupled as possible is one of the most valuable things you can do for a large system. In some cases you may have to make compromises (after all, you only have so much memory on your workstation), but such cases must be handled carefully and intentionally.


## Conventions

  - Since I am running this from a Windows machine, each of my stack folders contains a Powershell script titled `up.ps1`. This just makes it super easy to deploy or update a specific stack.
  - Swarm stacks and services are named using underscore_case. When swarm creates the full name of a service in a stack it will have the following form which makes it easy to distinguish the stack and service names, and also eliminates name collisions: <pre><span style="color:green">stack_name</span>-<span style="color:orange">service_name</span>
