/Oracle/app/oracle/product/db11g/bin/rman nocatalog target / << EOF
sql 'alter system archive log current';
run{
 allocate channel abc device type disk;
 crosscheck archivelog all;
 delete noprompt expired archivelog all;
 DELETE NOPROMPT OBSOLETE RECOVERY WINDOW OF 5 DAYS;
 delete noprompt archivelog all completed before 'sysdate-5';
 release channel abc;
}
EOF
