#!/usr/bin/env bash
# Polls nvidia-smi and outputs JSON for Wayle's custom module
nvidia-smi \
  --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu \
  --format=csv,noheader,nounits |
  awk -F', ' '{
    util=$1; vram_used=$2; vram_total=$3; temp=$4;
    vram_gib_used=vram_used/1024; vram_gib_total=vram_total/1024;
    printf "{\"util\":%d,\"vram_used\":%.1f,\"vram_total\":%.1f,\"temp\":%d}\n",
           util, vram_gib_used, vram_gib_total, temp
}'
