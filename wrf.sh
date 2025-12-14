################################################################################
#                        NWP & DATA ASSIMILATION 
# Written by Phinous for the IMSA Data Assimilation and NWP Training 
################################################################################  
### Go to wps and clean the environment

#To downlad the data

./data_imsa.sh

cd /home/nwp/IMSA01/Build_WRF/NWP/WPS

rm -f geo_em.d0* GRIBFILE.A* FILE* met_em.d0*

#Running geogrid to process IBCs

#Process data from WPS_GEOG

./geogrid.exe

#Be sure to clear previous files 

rm -f GRIBFILE.A* FILE* met_em.d0*

#Linking GFS IBCs from NOAA 

./link_grib.csh $HOME/Build_WRF/NWP/gfs/20251212/00z/gfs*

#Convert the files from grib to intermediate formats.. 

./ungrib.exe

#cp geogrid/GEOGRID.TBL ./
#cp metgrid/METGRID.TBL ./
#Copy vTABLES:
#cp ungrib/Variable_Tables/Vtable.GFS .
#Then rename the file
#mv Vtable.GFS Vtable

ll -lht

./metgrid.exe

###############################################################

cd $HOME/Build_WRF/WRF-4.5-ARW/run

rm -f wrfout_d0* wrfbdy_d01 wrfinput_d0* met_em*

# Link the met_em files from your WPS directory
ln -sf ~/Build_WRF/WPS-4.5/met_em.d01* .

./real.exe

tail rsl.out.0000

nohup ./wrf.exe &

tail -f rsl.out.0000


#  gnome-terminal -- bash -c "tail -f rsl.out.0000; exec bash"

#         mpirun -np 8 ./real.exe
        
#         mpirun -np 8 ./wrf.exe
        
################################################################################
#                        DATA ASSIMILATION 
################################################################################      
        
    
###########################################################################################

#PROCESSING THE OBSERVATIONS TO Littler format

###########################################################################################

# cd /home/nwp/IMSA01/NWP/DVAR/LITTLER/out/
# rm -rf *

# cd /home/nwp/IMSA01/NWP/DVAR/LITTLER/
# rm -rf 2021*

# ./ogmet_00data.sh
# ./ogmet_00perl.pl

# f95 00Obs2Littler.f90 -o littler
# littler

###############################################################################
    
  
    

# USEFUL SCRIPTS

#   sudo apt-get install firefox gedit 
#   https://gdex.ucar.edu/datasets/d337000/dataaccess/
  
# #Copy from my computer to remote computer
#   rsync -zaP /home/yyy/pp.sh nwp@172.16.52.48:/home/nwp/IMSA/phinous/model/
   
# # PREPBUFR
# #        https://rda.ucar.edu/datasets/ds337.0/dataaccess/     
        
        
        
        
        
exit
