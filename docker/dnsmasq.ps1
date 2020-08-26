docker run `
	--name dnsmasq `
    -d `
    --cap-add=NET_ADMIN `
	-p 5053:53/udp `
	-p 5380:8080 `
	-v $PSScriptRoot/dnsmasq/dnsmasq.conf:/etc/dnsmasq.conf `
	--log-opt "max-size=100m" `
	-e "HTTP_USER=foo" `
	-e "HTTP_PASS=bar" `
    --restart always `
    --net edge-overlay `
    --dns-opt 
	jpillora/dnsmasq