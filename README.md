# Unraid-Utils

Lightweight utilities for Unraid: automation, monitoring, and more.

## Overview

This repository contains a collection of Bash scripts designed to automate and manage tasks on an Unraid server. These utilities focus on enhancing server efficiency, particularly around service management and power events.

## Scripts

### plex-ups-shutdown.sh
* **Purpose**: Stops the Plex Media Server container during UPS power events.
* **Behavior**: Monitors UPS status via NUT. If on battery power (OB) with battery charge ≤ 65% or runtime ≤ 3600 seconds, it stops Plex and logs the reason to /mnt/cache/config/plex-stopped-by.
* **Requirements**: Docker, NUT (Network UPS Tools) configured with a UPS named cyberpowerups.

### start-plex-on-power-return.sh
* **Purpose**: Restarts Plex when UPS power conditions recover.
* **Behavior**: If Plex was stopped by a UPS event, checks UPS status. Restarts Plex when on line power (OL) with battery charge > 65% and runtime > 3600 seconds, then clears the stop reason file.
* **Requirements**: Same as above, plus a prior run of plex-ups-shutdown.sh to set the stop reason.

## Prerequisites

* **Unraid**: Scripts are tailored for Unraid's environment.
* **User Scripts Plugin**: For easy script scheduling within Unraid's UI.
* **Docker**: For managing containers like Plex Media Server.
* **NUT**: Installed and configured to monitor a UPS (e.g., cyberpowerups).
* **Permissions**: Scripts need execute permissions (chmod +x script.sh).

## Installation

1. Clone the repo:
```bash
git clone https://github.com/HagopA/Unraid-Utils.git
```
2. Install the User Scripts plugin from Unraid’s Community Applications if not already present.
3. In the User Scripts plugin, add a new script, copy the code from plex-ups-shutdown.sh or start-plex-on-power-return.sh, and save.
4. Set up a CRON job in the User Scripts plugin to run the scripts periodically.

## Usage

* Run manually: `./plex-ups-shutdown.sh` or `./start-plex-on-power-return.sh`.
* Automate: Schedule with the User Scripts plugin or cron (e.g., every minute):
```bash
* * * * *
```
