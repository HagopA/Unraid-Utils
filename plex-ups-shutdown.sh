#!/bin/bash

# Check if Plex container is running
plex_status=$(docker inspect -f '{{.State.Running}}' Plex-Media-Server)

# Only proceed if Plex is running
if [[ "$plex_status" == "true" ]]; then
    # Get UPS status from NUT
    ups_status=$(upsc cyberpowerups ups.status)

    # Check if UPS is on battery power (OB means "On Battery")
    if [[ "$ups_status" =~ "OB" ]]; then
	
		# Get UPS data from NUT
	    battery_charge=$(upsc cyberpowerups battery.charge)
		runtime=$(upsc cyberpowerups battery.runtime)
	
        # Stop Plex if battery charge <= 65% or runtime <= 3600 seconds
        if [[ "$battery_charge" -le 65 || "$runtime" -le 3600 ]]; then
            docker stop Plex-Media-Server
            
            # Ensure the config directory exists
            mkdir -p /mnt/cache/config
            
            # Write the reason for stopping to a file
            echo "UPS" > /mnt/cache/config/plex-stopped-by
        fi
    fi
fi
