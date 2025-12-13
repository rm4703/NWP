#!/bin/bash

# ==============================================================================
#  GFS REGIONAL DOWNLOADER (UNIVERSAL PATHS)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. CONFIGURATION (EDIT THIS SECTION)
# ------------------------------------------------------------------------------

# --- WHERE TO SAVE? ---
# "$HOME" automatically detects your home folder (e.g., /home/rmdmk)
# The script will create 'Training/gfs' inside your home folder.
TARGET_ROOT_DIR="$HOME/Training/gfs"

# --- DATE & CYCLE ---
# Option A: Automatic (Yesterday)
# DATE_STR=$(date -d "yesterday" +"%Y%m%d")

# Option B: Manual (Specific Date)
DATE_STR="20251211"
CYCLE="00"

# --- REGION BOUNDARIES ---
# Define the box to download (East Africa Example)
LEFT_LON="15"
RIGHT_LON="58"
TOP_LAT="20"
BOTTOM_LAT="-15"

# ------------------------------------------------------------------------------
# 2. DIRECTORY CREATION LOGIC
# ------------------------------------------------------------------------------

# Define the full path: /home/user/Training/gfs/20251211/00z
FINAL_DIR="${TARGET_ROOT_DIR}/${DATE_STR}/${CYCLE}z"

echo "--------------------------------------------------------"
echo "Checking directory status..."
echo "Target Path: $FINAL_DIR"

if [ ! -d "$FINAL_DIR" ]; then
    echo "Directory not found."
    echo "Creating directory structure..."
    # mkdir -p creates all necessary parent folders automatically
    mkdir -p "$FINAL_DIR"
else
    echo "Directory exists."
fi

# Enter the directory
cd "$FINAL_DIR" || { echo "ERROR: Could not enter $FINAL_DIR"; exit 1; }

echo "--------------------------------------------------------"
echo "Starting Download Routine"
echo "Date:   $DATE_STR ($CYCLE z)"
echo "Region: Lon ${LEFT_LON}to${RIGHT_LON} / Lat ${BOTTOM_LAT}to${TOP_LAT}"
echo "--------------------------------------------------------"

# ------------------------------------------------------------------------------
# 3. DOWNLOAD LOOP
# ------------------------------------------------------------------------------

for HR in $(seq -f "%03g" 0 3 123); do

    FILE="gfs.t${CYCLE}z.pgrb2.0p25.f${HR}"
    
    # URL construction
    URL="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=${FILE}&subregion=&leftlon=${LEFT_LON}&rightlon=${RIGHT_LON}&toplat=${TOP_LAT}&bottomlat=${BOTTOM_LAT}&dir=%2Fgfs.${DATE_STR}%2F${CYCLE}%2Fatmos"

    echo "Downloading: $FILE ..."

    curl -s -S "$URL" -o "$FILE"

    # Check file size
    FILESIZE=$(stat -c%s "$FILE")
    if [ "$FILESIZE" -lt 10000 ]; then
        echo "  [WARNING] File too small ($FILESIZE bytes). Data likely unavailable."
        rm "$FILE"
    fi

done

echo "--------------------------------------------------------"
echo "Process Complete."
echo "Files located in: $FINAL_DIR"
echo "--------------------------------------------------------"