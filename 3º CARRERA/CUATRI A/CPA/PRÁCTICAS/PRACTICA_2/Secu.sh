#!/bin/sh                                                                       
#PBS -l nodes=1,walltime=00:10:00
#PBS -q cpa                                                                           
#PBS -d .
./planets1 80000
