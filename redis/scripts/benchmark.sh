#!/bin/bash
docker run -it --network host --rm redis redis-benchmark -q -n 100000 -c 50 -P 12
