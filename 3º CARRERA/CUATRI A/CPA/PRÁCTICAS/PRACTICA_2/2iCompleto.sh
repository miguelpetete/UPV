#!/bin/sh                                                                       
#PBS -l nodes=1,walltime=00:10:00
#PBS -q cpa                                                                           
#PBS -d .
OMP_SCHEDULE="static,1" OMP_NUM_THREADS=2 ./planets2i 80000
OMP_SCHEDULE="dynamic,1" OMP_NUM_THREADS=2 ./planets2i 80000
OMP_SCHEDULE="static,1" OMP_NUM_THREADS=4 ./planets2i 80000
OMP_SCHEDULE="dynamic,1" OMP_NUM_THREADS=4 ./planets2i 80000
OMP_SCHEDULE="static,1" OMP_NUM_THREADS=8 ./planets2i 80000
OMP_SCHEDULE="dynamic,1" OMP_NUM_THREADS=8 ./planets2i 80000
OMP_SCHEDULE="static,1" OMP_NUM_THREADS=16 ./planets2i 80000
OMP_SCHEDULE="dynamic,1" OMP_NUM_THREADS=16 ./planets2i 80000
OMP_SCHEDULE="static,1" OMP_NUM_THREADS=32 ./planets2i 80000
OMP_SCHEDULE="dynamic,1" OMP_NUM_THREADS=32 ./planets2i 80000
OMP_SCHEDULE="static,1" OMP_NUM_THREADS=64 ./planets2i 80000
OMP_SCHEDULE="dynamic,1" OMP_NUM_THREADS=64 ./planets2i 80000
