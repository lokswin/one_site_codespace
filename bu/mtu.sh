#!/bin/bash
# file ./scripts/mtu.sh

# Script to change the MTU of a network interface inside the container

# Define the interface name (e.g., eth0) and desired MTU value
INTERFACE_NAME="eth0"
MTU_VALUE="1450"

# Change the MTU
#ip link set dev $INTERFACE_NAME mtu $MTU_VALUE

# Verify the change
#

ifconfig $INTERFACE_NAME mtu $MTU_VALUE

# Verify the change
ifconfig $INTERFACE_NAME