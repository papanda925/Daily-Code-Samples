import argparse
import ipaddress

parser = argparse.ArgumentParser()
parser.add_argument("network", nargs="?", default="192.168.1.0/24")
args = parser.parse_args()

try:
    net = ipaddress.ip_network(args.network, strict=True)
except ValueError as exc:
    print(f"FAILED: {exc}")
    raise SystemExit(1)

hosts = list(net.hosts())
print(f"SUCCESS network={net.network_address}")
print(f"prefix=/{net.prefixlen}")
print(f"broadcast={net.broadcast_address}")
print(f"addresses={net.num_addresses}")
print(f"usable_hosts={len(hosts)}")
if hosts:
    print(f"first_host={hosts[0]}")
    print(f"last_host={hosts[-1]}")
