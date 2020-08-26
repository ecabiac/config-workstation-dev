agent -ui
        -client='0.0.0.0'
        -bind='{{ GetInterfaceIP "eth1" }}'
        -advertise='{{ GetInterfaceIP "eth1" }}'
        -grpc-port 8502
        -datacenter="emc-local"
        -retry-join="consulmaster.mesh.devlocal"
        -encrypt="r17mGUbowVkYC3Xo7dW+PQ=="

function StartConsulServer() {
    docker run --name consulmaster1 -d -p 8502 -p 8300/tcp `
    agent -ui `
    -client='0.0.0.0' `
    -bind='0.0.0.0' `
    -advertise='consulmaster1.mesh.devmesh' `
    -grpc-port 8502 `
    -datacenter="devlocal" `
    -encrypt="r17mGUbowVkYC3Xo7dW+PQ=="
}

# assume that the host machine is "192.168.65.2" which is what 'host.docker.internal' resolves to in my hosts file (currently)
$hostip="192.168.65.2"
docker service create --name consulmaster1 -d -p 18500:18500/tcp -p 18600:18600/tcp -p 18600:18600/udp -p 18300:18300/tcp -p 18301-18302:18301-18302/tcp -p 18301-18302:18301-18302/udp consul:1.7.2 agent -server -bootstrap -client='0.0.0.0' -bind='0.0.0.0' -advertise="$hostip" datacenter="devlocal" -encrypt="r17mGUbowVkYC3Xo7dW+PQ==" -http-port=18500 -serf-lan-port=18301 -serf-wan-port=18302 -server-port=18300 -dns-port=18600
#docker service create --name consulmaster1 -d -p 8502 -p 8300/tcp consul:1.7.2 agent -server -client='0.0.0.0' -bind='0.0.0.0' -advertise="$hostip" -grpc-port=8502 -datacenter="devlocal" -encrypt="r17mGUbowVkYC3Xo7dW+PQ=="

docker run --name consulmaster1 -d -p 8502 -p 8300/tcp consul:1.7.2 agent -ui -client='0.0.0.0' -bind='0.0.0.0' -advertise='{{ GetInterfaceIP "eth1" }}' -grpc-port=8502 -datacenter="devlocal" -encrypt="r17mGUbowVkYC3Xo7dW+PQ=="
            
docker service create --name consulmaster1 -d -p 8502 -p 8300/tcp consul:1.7.2 agent -ui -client='0.0.0.0' -bind='0.0.0.0' -advertise='{{ GetInterfaceIP "eth1" }}' -grpc-port=8502 -datacenter="devlocal" -encrypt="r17mGUbowVkYC3Xo7dW+PQ=="

docker service create --name consulmaster1 -d -p 8502 -p 8300/tcp consul:1.7.2 agent -ui -client='0.0.0.0' -bind='192.168.65.2' -advertise='192.168.65.2' -grpc-port=8502 -datacenter="devlocal" -encrypt="r17mGUbowVkYC3Xo7dW+PQ=="

docker service create --name ubuserver -p 8502 -p 8300/tcp ecabiac/myubuntu bash sleep 600000