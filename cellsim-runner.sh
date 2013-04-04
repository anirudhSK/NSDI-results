#!/bin/bash

exec /home/ubuntu/multisend/sender/cellsim /home/ubuntu/uplink-good-chunk.verizon /home/ubuntu/downlink-good-chunk.verizon 00:00:00:00:00:02 0 LTE-eth0 LTE-eth1 >/tmp/cellsim-stdout 2>/tmp/cellsim-stderr
