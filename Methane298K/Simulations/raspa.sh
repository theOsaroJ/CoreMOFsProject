#!/bin/bash
if [ -r /opt/crc/Modules/current/init/bash ]; then
        source /opt/crc/Modules/current/init/bash
fi
# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

cd /scratch365/eosaro/Research/CoreMOFs/MPNN_CoRE-ASR/CH4/AllSimulations/FFF/INDEX/
export HOME="/scratch365/eosaro"
export RASPA_DIR=${HOME}/RASPA/simulations
export DYLD_LIBRARY_PATH=${RASPA_DIR}/lib
export LD_LIBRARY_PATH=${RASPA_DIR}/lib:$LD_LIBRARY_PATH
$RASPA_DIR/bin/simulate -i simulation.input
