#!/usr/bin/env bash
# Generates real traffic (including some 404s and 401s) so the Grafana panels show data.
# Usage: ./k8s/monitoring/load-test.sh 35.178.115.47
IP="${1:?usage: $0 <public-ip>}"
for i in $(seq 1 300); do
  curl -s -o /dev/null "http://$IP/api/products"
  curl -s -o /dev/null "http://$IP/api/products?category=home"
  curl -s -o /dev/null "http://$IP/api/store"
  curl -s -o /dev/null "http://$IP/api/products/999"                       # 404
  curl -s -o /dev/null -X POST "http://$IP/api/cart/validate" \
       -H 'Content-Type: application/json' -d '{"items":[]}'                # 401 (no API key)
  sleep 0.5
done
echo "Done: sent $((300*5)) requests"
