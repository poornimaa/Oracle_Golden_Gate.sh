#!/bin/sh
export REGION=EU
PATH=$PATH:$HOME/bin
PATH=$PATH:$HOME/bin
export ORACLE_BASE=/GG/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.1.0/client
export GOLDEN_GATE_HOME=$ORACLE_BASE/product/12.1.2/oggcore_1
export PATH=$PATH:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export NLS_LANG=AMERICAN_AMERICA.UTF8
unset USERNAME
PS1='$USER:$ORACLE_SID:$PWD\$ '
export PATH
ulimit -u 16384
umask 022

export PATH
export EMSUSER=emsuser
export EMSPASS=emsuser4dba

CHECK_DATE=`date +"%Y%m%d%H%M%S"`

cd $GOLDEN_GATE_HOME

echo "set echo off" > /tmp/insert_gg_status.sql
echo "set feed off" >> /tmp/insert_gg_status.sql
echo "set pages 0" >> /tmp/insert_gg_status.sql

echo "`./ggsci << EOF
info all
exit
EOF
`" | grep -E 'MANAGER|EXTRACT|REPLICAT' | awk {'print "INSERT INTO GG_STATUS_HIST (check_date, region, program, group_name, status, lag_at_chkpt, time_since_chkpt) VALUES (TO_DATE(\047" "'$CHECK_DATE'" "\047, \047YYYYMMDDHH24MISS\047), \047" "'$REGION'" "\047, \047" $1 "\047, NVL(\047" $3 "\047,\047-\047), \047" $2 "\047,\047" $4 "\047,\047" $5 "\047);"'} >> /tmp/insert_gg_status.sql

echo "`./ggsci << EOF
info all
exit
EOF
`" | grep -E 'EXTRACT|REPLICAT' | awk {'print "echo -n \"UPDATE GG_STATUS_HIST SET TOTAL_OPERATIONS = \" >> /tmp/insert_gg_status.sql; echo -n \"`./ggsci << EOF\012stats " $1 " " $3 " totalsonly *.*\012exit\012EOF\012`\" | grep \047Total operations\047 | head -1 | awk {\047print \"NVL(TO_NUMBER(\\047\" $3 \"\\047),0)\"\047} >> /tmp/insert_gg_status.sql; echo \" WHERE CHECK_DATE = TO_DATE(\047" "'$CHECK_DATE'" "\047, \047YYYYMMDDHH24MISS\047) AND REGION = \047" "'$REGION'" "\047 and PROGRAM = \047" $1 "\047 AND GROUP_NAME = \047" $3 "\047;\" >> /tmp/insert_gg_status.sql"'} > /tmp/insert_gg_status.sh

/bin/sh /tmp/insert_gg_status.sh

echo "`./ggsci << EOF
info all
exit
EOF
`" | grep -E 'EXTRACT|REPLICAT' | awk {'print "echo -n \"UPDATE GG_STATUS_HIST SET TOTAL_DISCARDS = \" >> /tmp/insert_gg_status.sql; echo -n \"`./ggsci << EOF\012stats " $1 " " $3 " totalsonly *.*\012exit\012EOF\012`\" | grep \047Total discards\047 | head -1 | awk {\047print \"NVL(TO_NUMBER(\\047\" $3 \"\\047),0)\"\047} >> /tmp/insert_gg_status.sql; echo \" WHERE CHECK_DATE = TO_DATE(\047" "'$CHECK_DATE'" "\047, \047YYYYMMDDHH24MISS\047) AND REGION = \047" "'$REGION'" "\047 and PROGRAM = \047" $1 "\047 AND GROUP_NAME = \047" $3 "\047;\" >> /tmp/insert_gg_status.sql"'} > /tmp/insert_gg_status.sh

/bin/sh /tmp/insert_gg_status.sh

echo "COMMIT;" >> /tmp/insert_gg_status.sql
echo "EXIT" >> /tmp/insert_gg_status.sql

sed -i 's/TOTAL_OPERATIONS =  WHERE/TOTAL_OPERATIONS = 0 WHERE/' /tmp/insert_gg_status.sql
sed -i 's/TOTAL_DISCARDS =  WHERE/TOTAL_DISCARDS = 0 WHERE/' /tmp/insert_gg_status.sql

sqlplus -S $EMSUSER/$EMSPASS@ALMA.ARC.EU @/tmp/insert_gg_status.sql
echo "`date`" >> /home/oracle/ems/insert_gg_status.log
arcgg1:oracle::/home/oracle/ems$ cat insert_gg_status1.sh
#!/bin/sh
export REGION=EU
PATH=$PATH:$HOME/bin
PATH=$PATH:$HOME/bin
export ORACLE_BASE=/GG/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.1.0/client
export GOLDEN_GATE_HOME=$ORACLE_BASE/product/12.1.2/oggcore_1
export PATH=$PATH:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export NLS_LANG=AMERICAN_AMERICA.UTF8
unset USERNAME
PS1='$USER:$ORACLE_SID:$PWD\$ '
export PATH
ulimit -u 16384
umask 022

export PATH
export EMSUSER=emsuser
export EMSPASS=emsuser4dba

CHECK_DATE=`date +"%Y%m%d%H%M%S"`

cd $GOLDEN_GATE_HOME

echo "set echo off" > /tmp/insert_gg_status.sql
echo "set feed off" >> /tmp/insert_gg_status.sql
echo "set pages 0" >> /tmp/insert_gg_status.sql

echo "`./ggsci << EOF
info all
exit
EOF
`" | grep -E 'MANAGER|EXTRACT|REPLICAT' | awk {'print "INSERT INTO GG_STATUS_HIST (check_date, region, program, group_name, status, lag_at_chkpt, time_since_chkpt) VALUES (TO_DATE(\047" "'$CHECK_DATE'" "\047, \047YYYYMMDDHH24MISS\047), \047" "'$REGION'" "\047, \047" $1 "\047, NVL(\047" $3 "\047,\047-\047), \047" $2 "\047,\047" $4 "\047,\047" $5 "\047);"'} >> /tmp/insert_gg_status.sql

echo "`./ggsci << EOF
info all
exit
EOF
`" | grep -E 'EXTRACT|REPLICAT' | awk {'print "echo -n \"UPDATE GG_STATUS_HIST SET TOTAL_OPERATIONS = \" >> /tmp/insert_gg_status.sql; echo -n \"`./ggsci << EOF\012stats " $1 " " $3 " totalsonly *.*\012exit\012EOF\012`\" | grep \047Total operations\047 | head -1 | awk {\047print \"NVL(TO_NUMBER(\\047\" $3 \"\\047),0)\"\047} >> /tmp/insert_gg_status.sql; echo \" WHERE CHECK_DATE = TO_DATE(\047" "'$CHECK_DATE'" "\047, \047YYYYMMDDHH24MISS\047) AND REGION = \047" "'$REGION'" "\047 and PROGRAM = \047" $1 "\047 AND GROUP_NAME = \047" $3 "\047;\" >> /tmp/insert_gg_status.sql"'} > /tmp/insert_gg_status.sh

/bin/sh /tmp/insert_gg_status.sh

echo "`./ggsci << EOF
info all
exit
EOF
`" | grep -E 'EXTRACT|REPLICAT' | awk {'print "echo -n \"UPDATE GG_STATUS_HIST SET TOTAL_DISCARDS = \" >> /tmp/insert_gg_status.sql; echo -n \"`./ggsci << EOF\012stats " $1 " " $3 " totalsonly *.*\012exit\012EOF\012`\" | grep \047Total discards\047 | head -1 | awk {\047print \"NVL(TO_NUMBER(\\047\" $3 \"\\047),0)\"\047} >> /tmp/insert_gg_status.sql; echo \" WHERE CHECK_DATE = TO_DATE(\047" "'$CHECK_DATE'" "\047, \047YYYYMMDDHH24MISS\047) AND REGION = \047" "'$REGION'" "\047 and PROGRAM = \047" $1 "\047 AND GROUP_NAME = \047" $3 "\047;\" >> /tmp/insert_gg_status.sql"'} > /tmp/insert_gg_status.sh

/bin/sh /tmp/insert_gg_status.sh

echo "COMMIT;" >> /tmp/insert_gg_status.sql
echo "EXIT" >> /tmp/insert_gg_status.sql

sed -i 's/TOTAL_OPERATIONS =  WHERE/TOTAL_OPERATIONS = 0 WHERE/' /tmp/insert_gg_status.sql
sed -i 's/TOTAL_DISCARDS =  WHERE/TOTAL_DISCARDS = 0 WHERE/' /tmp/insert_gg_status.sql

sqlplus -S $EMSUSER/$EMSPASS@ALMA.ARC.EU @/tmp/insert_gg_status.sql
echo "`date`" >> /home/oracle/ems/insert_gg_status.log
arcgg1:oracle::/home/oracle/ems$
arcgg1:oracle::/home/oracle/ems$
arcgg1:oracle::/home/oracle/ems$
arcgg1:oracle::/home/oracle/ems$
arcgg1:oracle::/home/oracle/ems$
arcgg1:oracle::/home/oracle/ems$ clear
arcgg1:oracle::/home/oracle/ems$ cat insert_gg_status1.sh
#!/bin/sh
export REGION=EU
PATH=$PATH:$HOME/bin
PATH=$PATH:$HOME/bin
export ORACLE_BASE=/GG/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.1.0/client
export GOLDEN_GATE_HOME=$ORACLE_BASE/product/12.1.2/oggcore_1
export PATH=$PATH:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export NLS_LANG=AMERICAN_AMERICA.UTF8
unset USERNAME
PS1='$USER:$ORACLE_SID:$PWD\$ '
export PATH
ulimit -u 16384
umask 022

export PATH
export EMSUSER=emsuser
export EMSPASS=emsuser4dba

CHECK_DATE=`date +"%Y%m%d%H%M%S"`

cd $GOLDEN_GATE_HOME

echo "set echo off" > /tmp/insert_gg_status.sql
echo "set feed off" >> /tmp/insert_gg_status.sql
echo "set pages 0" >> /tmp/insert_gg_status.sql

echo "`./ggsci << EOF
info all
exit
EOF
`" | grep -E 'MANAGER|EXTRACT|REPLICAT' | awk {'print "INSERT INTO GG_STATUS_HIST (check_date, region, program, group_name, status, lag_at_chkpt, time_since_chkpt) VALUES (TO_DATE(\047" "'$CHECK_DATE'" "\047, \047YYYYMMDDHH24MISS\047), \047" "'$REGION'" "\047, \047" $1 "\047, NVL(\047" $3 "\047,\047-\047), \047" $2 "\047,\047" $4 "\047,\047" $5 "\047);"'} >> /tmp/insert_gg_status.sql

echo "`./ggsci << EOF
info all
exit
EOF
`" | grep -E 'EXTRACT|REPLICAT' | awk {'print "echo -n \"UPDATE GG_STATUS_HIST SET TOTAL_OPERATIONS = \" >> /tmp/insert_gg_status.sql; echo -n \"`./ggsci << EOF\012stats " $1 " " $3 " totalsonly *.*\012exit\012EOF\012`\" | grep \047Total operations\047 | head -1 | awk {\047print \"NVL(TO_NUMBER(\\047\" $3 \"\\047),0)\"\047} >> /tmp/insert_gg_status.sql; echo \" WHERE CHECK_DATE = TO_DATE(\047" "'$CHECK_DATE'" "\047, \047YYYYMMDDHH24MISS\047) AND REGION = \047" "'$REGION'" "\047 and PROGRAM = \047" $1 "\047 AND GROUP_NAME = \047" $3 "\047;\" >> /tmp/insert_gg_status.sql"'} > /tmp/insert_gg_status.sh

/bin/sh /tmp/insert_gg_status.sh

echo "`./ggsci << EOF
info all
exit
EOF
`" | grep -E 'EXTRACT|REPLICAT' | awk {'print "echo -n \"UPDATE GG_STATUS_HIST SET TOTAL_DISCARDS = \" >> /tmp/insert_gg_status.sql; echo -n \"`./ggsci << EOF\012stats " $1 " " $3 " totalsonly *.*\012exit\012EOF\012`\" | grep \047Total discards\047 | head -1 | awk {\047print \"NVL(TO_NUMBER(\\047\" $3 \"\\047),0)\"\047} >> /tmp/insert_gg_status.sql; echo \" WHERE CHECK_DATE = TO_DATE(\047" "'$CHECK_DATE'" "\047, \047YYYYMMDDHH24MISS\047) AND REGION = \047" "'$REGION'" "\047 and PROGRAM = \047" $1 "\047 AND GROUP_NAME = \047" $3 "\047;\" >> /tmp/insert_gg_status.sql"'} > /tmp/insert_gg_status.sh

/bin/sh /tmp/insert_gg_status.sh

echo "COMMIT;" >> /tmp/insert_gg_status.sql
echo "EXIT" >> /tmp/insert_gg_status.sql

sed -i 's/TOTAL_OPERATIONS =  WHERE/TOTAL_OPERATIONS = 0 WHERE/' /tmp/insert_gg_status.sql
sed -i 's/TOTAL_DISCARDS =  WHERE/TOTAL_DISCARDS = 0 WHERE/' /tmp/insert_gg_status.sql

sqlplus -S $EMSUSER/$EMSPASS@ALMA.ARC.EU @/tmp/insert_gg_status.sql
echo "`date`" >> /home/oracle/ems/insert_gg_status.log
arcgg1:oracle::/home/oracle/ems$ ls
insert_gg_status1.sh  insert_gg_status.log  insert_gg_status.sh  insert_gg_status.sh.old
arcgg1:oracle::/home/oracle/ems$ cat insert_gg_status1.sh
#!/bin/sh
export REGION=EU
PATH=$PATH:$HOME/bin
PATH=$PATH:$HOME/bin
export ORACLE_BASE=/GG/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.1.0/client
export GOLDEN_GATE_HOME=$ORACLE_BASE/product/12.1.2/oggcore_1
export PATH=$PATH:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export NLS_LANG=AMERICAN_AMERICA.UTF8
unset USERNAME
PS1='$USER:$ORACLE_SID:$PWD\$ '
export PATH
ulimit -u 16384
umask 022

export PATH
export EMSUSER=emsuser
export EMSPASS=emsuser4dba

CHECK_DATE=`date +"%Y%m%d%H%M%S"`

cd $GOLDEN_GATE_HOME

echo "set echo off" > /tmp/insert_gg_status.sql
echo "set feed off" >> /tmp/insert_gg_status.sql
echo "set pages 0" >> /tmp/insert_gg_status.sql

echo "`./ggsci << EOF
info all
exit
EOF
`" | grep -E 'MANAGER|EXTRACT|REPLICAT' | awk {'print "INSERT INTO GG_STATUS_HIST (check_date, region, program, group_name, status, lag_at_chkpt, time_since_chkpt) VALUES (TO_DATE(\047" "'$CHECK_DATE'" "\047, \047YYYYMMDDHH24MISS\047), \047" "'$REGION'" "\047, \047" $1 "\047, NVL(\047" $3 "\047,\047-\047), \047" $2 "\047,\047" $4 "\047,\047" $5 "\047);"'} >> /tmp/insert_gg_status.sql

echo "`./ggsci << EOF
info all
exit
EOF
`" | grep -E 'EXTRACT|REPLICAT' | awk {'print "echo -n \"UPDATE GG_STATUS_HIST SET TOTAL_OPERATIONS = \" >> /tmp/insert_gg_status.sql; echo -n \"`./ggsci << EOF\012stats " $1 " " $3 " totalsonly *.*\012exit\012EOF\012`\" | grep \047Total operations\047 | head -1 | awk {\047print \"NVL(TO_NUMBER(\\047\" $3 \"\\047),0)\"\047} >> /tmp/insert_gg_status.sql; echo \" WHERE CHECK_DATE = TO_DATE(\047" "'$CHECK_DATE'" "\047, \047YYYYMMDDHH24MISS\047) AND REGION = \047" "'$REGION'" "\047 and PROGRAM = \047" $1 "\047 AND GROUP_NAME = \047" $3 "\047;\" >> /tmp/insert_gg_status.sql"'} > /tmp/insert_gg_status.sh

/bin/sh /tmp/insert_gg_status.sh

echo "`./ggsci << EOF
info all
exit
EOF
`" | grep -E 'EXTRACT|REPLICAT' | awk {'print "echo -n \"UPDATE GG_STATUS_HIST SET TOTAL_DISCARDS = \" >> /tmp/insert_gg_status.sql; echo -n \"`./ggsci << EOF\012stats " $1 " " $3 " totalsonly *.*\012exit\012EOF\012`\" | grep \047Total discards\047 | head -1 | awk {\047print \"NVL(TO_NUMBER(\\047\" $3 \"\\047),0)\"\047} >> /tmp/insert_gg_status.sql; echo \" WHERE CHECK_DATE = TO_DATE(\047" "'$CHECK_DATE'" "\047, \047YYYYMMDDHH24MISS\047) AND REGION = \047" "'$REGION'" "\047 and PROGRAM = \047" $1 "\047 AND GROUP_NAME = \047" $3 "\047;\" >> /tmp/insert_gg_status.sql"'} > /tmp/insert_gg_status.sh

/bin/sh /tmp/insert_gg_status.sh

echo "COMMIT;" >> /tmp/insert_gg_status.sql
echo "EXIT" >> /tmp/insert_gg_status.sql

sed -i 's/TOTAL_OPERATIONS =  WHERE/TOTAL_OPERATIONS = 0 WHERE/' /tmp/insert_gg_status.sql
sed -i 's/TOTAL_DISCARDS =  WHERE/TOTAL_DISCARDS = 0 WHERE/' /tmp/insert_gg_status.sql

sqlplus -S $EMSUSER/$EMSPASS@ALMA.ARC.EU @/tmp/insert_gg_status.sql
echo "`date`" >> /home/oracle/ems/insert_gg_status.log
