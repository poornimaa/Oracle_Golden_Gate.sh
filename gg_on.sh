#!/bin/bash
#############################################################################################
########### Arkadiusz Borucki
########### gg_on.sh - script is checking golden gate manager and replicant proccess status
########### returns 0 when is no replication problem and 1 or 2 or 3 or 4 or 5 or 6 or 7 when problem occure
########### 1 - mgr problem
########### 2 - rscatsdd problem
########### 3 - ralmasdd problem
########### 4 - ralmabeu problem
########### 5 - rscatbeu problem
########### 6 - ralmaeu2 problem
########### 7 - rscateu2 problem
#############################################################################################

DBA="aborucki@xxxxx"
ORACLE_SID="ALMA"
GOLDEN_GATE_HOME=/GG/app/oracle/product/12.1.2/oggcore_1
 ORACLE_HOME="/Oracle/app/oracle/product/db11g"

a=`ps aux | grep -v grep | grep mgr.prm | wc -l`
echo $a
if [ $a -eq 0 ]; then
echo "manager down"
return 1
exit
fi

b=`ps aux | grep -v grep | grep rscatsdd | wc -l`
echo $b
if [ $b -eq 0 ]; then
echo "replicat catalog rscatsdd down"
return 2
exit
fi

c=`ps aux | grep -v grep | grep ralmasdd | wc -l`
echo $c
if [ $c -eq 0 ]; then
echo "replicat alma xml rscatsdd down"
return 3
exit
fi

d=`ps aux | grep -v grep | grep ralmabeu | wc -l`
echo $d
if [ $d -eq 0 ]; then
echo "replicat alma xml xml ralmabeu down"
return 4
exit
fi

e=`ps aux | grep -v grep | grep rscatbeu | wc -l`
echo $e
if [ $e -eq 0 ]; then
echo "replicat alma catalog rscatbeu down"
return 5
exit
fi

f=`ps aux | grep -v grep | grep ralmaeu2 | wc -l`
echo $f
if [ $f -eq 0 ]; then
echo "replicat xml  ralmaeu2 down"
return 6
exit
fi

g=`ps aux | grep -v grep | grep rscateu2 | wc -l`
echo $g
if [ $g -eq 0 ]; then
echo "replicat  catalog rscateu2 down"
return 7
exit
fi
