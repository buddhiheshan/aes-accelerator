### calibre -gui -drc
mkdir rpt output log

set NUM_OF_CPU = 1

### sed Deck
set ProjRoot = ../

sed -i -e 's/^#DEFINE DUMMY_PRE_CHECK/\/\/#DEFINE DUMMY_PRE_CHECK/g' N16ADFP_DRC_Calibre_11M.11_1a.encrypt.modified
sed -i -e 's/\/\/#DEFINE UseprBoundary/#DEFINE UseprBoundary/g' N16ADFP_DRC_Calibre_11M.11_1a.encrypt.modified

calibre -drc -hier -64 -turbo $NUM_OF_CPU  -hyper -lmretry loop,maxretry:200,interval:200 runset.cmd | tee -i log/runset.log

mv -f *.density ./rpt
mv -f *.rep     ./rpt
