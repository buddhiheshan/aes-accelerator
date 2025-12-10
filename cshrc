#User need to set <tool_installation> to user's tool path

echo "Sourcing Xcelium license"
setenv XCELIUM /eda/cadence/XCELIUM2409

echo "Sourcing vManager license to lauch IMC tool"
setenv VMANAGER /eda/cadence/VMANAGER2503

echo "Sourcing Modus License"
setenv MODUS /eda/cadence/MODUS231

echo "Sourcing Conformal License"
setenv LEC /eda/cadence/CONFRML232

echo "Sourcing DDI221 for Genus License"
setenv GENUS  /eda/cadence/DDI231

echo "Sourcing DDI221 for Innovus License"
setenv INNOVUS  /eda/cadence/DDI231

echo "Sourcing SSVHOME License"
setenv TEMPUS  /eda/cadence/SSV231

#binary path updated for XCELIUM VMANAGER MODUS INNOVUS GENUS TEMPUS LEC binaries 4/11/2025
set path=( /usr/lib64 $XCELIUM/tools.lnx86/bin/64bit \
 $VMANAGER/bin \
 $MODUS/bin \
 $INNOVUS/bin \
 $GENUS/bin \
 $TEMPUS/bin \
 $LEC/bin \
 $CDSHOME/tools/dfII/bin \
 $MMSIM_HOME/bin \
 $MMSIM_HOME/dfII/bin \
 $CDS_DIR/bin \
 $CDS_DIR/dfII/bin \
 $CDS_DIR/SKILL37.00 \
 $CDS_DIR/dracula/bin \
 $PVSHOME/bin \
 $PVSHOME/tools/bin \
 $PVSHOME/tools/dfII/bin \
 $PVSHOME/tools/pvs/bin \
 $ASSURAHOME/tools/assura/bin \
 $SUBSTRATESTORMSITE $path )

foreach t ( xrun imc modus genus lec innovus tempus)
   echo "Found $t at `which $t`"
end

#
