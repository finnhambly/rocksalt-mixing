#!/bin/sh

for C in 4; do
  mkdir -p Mg${C}
  mpirun -np 1 ./castep.mpi MgO

  mv -u MgO.castep Mg${C}

  grep "Final energy" Mg${C}/MgO.castep > ${C}/finalenergy.dat

done
