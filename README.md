# Steinadler

## Overview

Steinadler is a high-level alternative to Erlang Distribution. 
While we are aware of the incredible capabilities of the Erlang Distribution we also know 
that there are numerous deficiencies in this protocol that we are trying to address.

The main points we try to attack is regarding the security of applications in a cluster. 
Although Erlang Distribution supports tls/ssl the setup to achieve this benefit is not simple, 
therefore we propose a simplified API for using TLS making all applications in a cluster communicate securely.

Another point has to do with scalability, Erlang Distribution has certain limits that we try to overcome with our approach 
making really large clusters possible. 
We also do this with a network topology that is easily bridged via NAT technologies and/or firewalls.

## Running locally

```sh
$ iex --name node1@ip -S mix

iex(1)> Steinadler.start_link([cluster_strategy: :gossip, default_port: 4001])

10:29:38.250 [debug] Starting node :"node@ip
```

In another terminal try:

```sh
$ iex --name node2@ip -S mix

iex(1)> Steinadler.start_link([cluster_strategy: :gossip, default_port: 4002])

10:29:38.250 [debug] Starting node :"node2@ip

10:29:41.392 [debug] Connecting with Node: "node1". On Address: "127.0.0.1"
 
10:29:41.392 [info]  [libcluster:steinadler] connected to :"node1@127.0.0.1"
 
```

## Project Status

- [x] Node discovery
- [x] gRPC Server
- [ ] gRPC Client
- [x] Execution of Functions on Remote Node
- [x] Caching of function arguments
- [x] Type Conversions
    - [x] String
    - [x] Atoms
    - [x] Integer
    - [x] Float
    - [ ] List
    - [ ] Map
    - [ ] Structs

## Benchmark

TODO