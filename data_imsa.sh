#!/bin/bash

# ==============================================================================
#  GFS REGIONAL DOWNLOADER 
# ==============================================================================

# 1. CONFIGURATION
# ------------------------------------------------------------------------------

# Updated path to match your working directory
TARGET_ROOT_DIR="$HOME/Build_WRF/NWP/gfs"

# --- DATE ---
# If you want a different date, change it here.
DATE_STR="20251212"
CYCLE="00"

# --- REGION BOUNDARIES ---
# Make sure that the WRF domain fits inside.
LEFT_LON="50"       # Expanded West
RIGHT_LON="110"     # Expanded East
TOP_LAT="50"        # Expanded North
BOTTOM_LAT="-10"    # Expanded South

# ------------------------------------------------------------------------------
# 2. DIRECTORY SETUP
# ------------------------------------------------------------------------------

FINAL_DIR="${TARGET_ROOT_DIR}/${DATE_STR}/${CYCLE}z"

echo "--------------------------------------------------------"
echo "Target Path: $FINAL_DIR"
mkdir -p "$FINAL_DIR"
cd "$FINAL_DIR" || { echo "ERROR: Could not enter $FINAL_DIR"; exit 1; }

echo "--------------------------------------------------------"
echo "Starting Download: Expanded India Domain"
echo "Date:   $DATE_STR ($CYCLE z)"
echo "Bounds: Lon ${LEFT_LON} to ${RIGHT_LON} / Lat ${BOTTOM_LAT} to ${TOP_LAT}"
echo "--------------------------------------------------------"

# ------------------------------------------------------------------------------
# 3. DOWNLOAD LOOP
# ------------------------------------------------------------------------------

for HR in $(seq -f "%03g" 0 3 123); do

    FILE="gfs.t${CYCLE}z.pgrb2.0p25.f${HR}"
    
    URL="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=${FILE}&subregion=&leftlon=${LEFT_LON}&rightlon=${RIGHT_LON}&toplat=${TOP_LAT}&bottomlat=${BOTTOM_LAT}&dir=%2Fgfs.${DATE_STR}%2F${CYCLE}%2Fatmos"

    echo "Downloading: $FILE ..."

    # --- FIX 1: CONNECTION STABILITY ---
    # --retry 3 : Try 3 times if NOAA kicks you off
    # --connect-timeout 30 : Don't freeze if internet is bad
    curl -f --retry 3 --retry-delay 5 --connect-timeout 30 -s -S "$URL" -o "$FILE"

    # Check file size
    if [ -f "$FILE" ]; then
        FILESIZE=$(stat -c%s "$FILE")
        if [ "$FILESIZE" -lt 10000 ]; then
            echo "  [WARNING] File too small ($FILESIZE bytes). Removing."
            rm "$FILE"
        else
            echo "  [SUCCESS] Saved."
        fi
    else
        echo "  [ERROR] Download failed."
    fi

    # --- FIX 2: PREVENT SERVER BLOCKING ---
    # Pause for 10 seconds so NOAA doesn't block your IP
    sleep 10

done

echo "--------------------------------------------------------"
echo "Process Complete."
echo "Files located in: $FINAL_DIR"
echo "--------------------------------------------------------"