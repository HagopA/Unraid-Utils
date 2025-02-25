#!/bin/bash

# Check if Plex container is stopped
plex_status=$(docker inspect -f '{{.State.Running}}' Plex-Media-Server)

# Only proceed if Plex is stopped
if [[ "$plex_status" == "false" ]]; then

    # Check if the Plex container was stopped due to a UPS event
    if [ -f /mnt/cache/config/plex-stopped-by ] && grep -q "UPS" /mnt/cache/config/plex-stopped-by; then
	
        # Get UPS status from NUT
        ups_status=$(upsc cyberpowerups ups.status)

        # Check if UPS is on line power (OL means "On Line")
        if [[ "$ups_status" =~ "OL" ]]; then
		
			# Get UPS data from NUT
		    battery_charge=$(upsc cyberpowerups battery.charge)
			runtime=$(upsc cyberpowerups battery.runtime)
		
            # Start Plex if battery charge > 65% and runtime > 3600 seconds
            if [[ "$battery_charge" -gt 65 && "$runtime" -gt 3600 ]]; then
                docker start Plex-Media-Server
                # Clear the stop reason file after starting
                rm /mnt/cache/config/plex-stopped-by
            fi
        fi
    fi
fi
