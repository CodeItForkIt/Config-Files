#!/usr/bin/env bash
nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu \
  --format=csv,noheader,nounits \
| awk -F', ' '{printf "{\"util\":%d,\"vram_used\":%.1f,\"vram_total\":%.1f,\"temp\":%d}\n", $1, $2/1024, $3/1024, $4}'
