import argparse
import ipaddress

parser = argparse.ArgumentParser()
parser.add_argument("network", nargs="?", default="192.168.1.10/24")
parser.add_argument("--strict", action=argparse.BooleanOptionalAction, default=True)
args = parser.parse_args()

print(f"[START] input={args.network} strict={args.strict}")
try:
    net = ipaddress.ip_network(args.network, strict=args.strict)
except ValueError as exc:
    print(f"[FAILED] {exc}")
    raise SystemExit(1)

print(f"[SUCCESS] normalized={net}")
print(f"network={net.network_address}")
print(f"prefix=/{net.prefixlen}")
print(f"broadcast={net.broadcast_address}")
print(f"addresses={net.num_addresses}")
