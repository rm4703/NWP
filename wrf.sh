#!/bin/bash

# ==============================================================================
# GFS DOWNLOADER (OPTIMIZED)
# ==============================================================================

# 1. CONFIGURATION
# ----------------
# Where to save the data?
BASE_DIR="/home/rmdmk/Training/gfs"

# DATE SETTING:
# Option A: Use System Date (Only works if your PC clock is correct!)
# THE_DATE=$(date -d "yesterday" +"%Y%m%d")

# Option B: Manual Date (SAFER - Use this if your PC clock says 2025)
# Set this to a date within the last 7 days (e.g., yesterday in real life)
THE_DATE="20251211"  # <--- CHANGE THIS TO THE REAL DATE YOU WANT

# Cycle (00z, 06z, 12z, 18z)
CYCLE="00"

# Create the folder
WORK_DIR="$BASE_DIR/$THE_DATE"
mkdir -p $WORK_DIR
cd $WORK_DIR || exit 1

echo "Downloading GFS data for Date: $THE_DATE (Cycle: $CYCLE)"
echo "Saving to: $WORK_DIR"

# 2. DOWNLOAD LOOP
# ----------------
# This loops from hour 000 to 123 in steps of 3 (000, 003, 006...)
for HR in $(seq -f "%03g" 0 3 123); do

    FILE_NAME="gfs.t${CYCLE}z.pgrb2.0p25.f${HR}"
    
    echo "Downloading forecast hour: $HR ..."

    # NOAA NOMADS URL (Sub-region download)
    # Note: I kept your lat/lon box (Africa/Middle East region?)
    curl -s "https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=${FILE_NAME}&subregion=&leftlon=22&rightlon=45&toplat=10&bottomlat=-8&dir=%2Fgfs.${THE_DATE}%2F${CYCLE}%2Fatmos" -o ${FILE_NAME}

    # Check if download worked (NOMADS returns a small HTML file if 404 error)
    FILESIZE=$(stat -c%s "$FILE_NAME")
    if [ "$FILESIZE" -lt 10000 ]; then
        echo "  [WARNING] File $FILE_NAME is too small ($FILESIZE bytes). The date/time might be wrong or data not available yet."
        # Optional: cat $FILE_NAME to see the error message
    fi

done

echo "Download process finished."
echo "Check your files in: $WORK_DIR"