#!/bin/bash

>finalenergy.dat
>rel_energies.dat
gfortran makestats.f90 -o makestats
for Ca in {0..8}; do
  Mg=$((8-$Ca))
  newdir=Mg${Mg}Ca${Ca}O8
  mkdir -p ${newdir}
  mpirun -np 1 ./castep.mpi MgO
  mv -u MgO.castep ${newdir}
  grep "Final energy" ${newdir}/MgO.castep | tail -1 | awk '{print $5}' > ${newdir}/finalenergy.dat
  echo $newdir > read.in
  echo $Mg >> read.in
  ./makestats < read.in
  echo "title \"Change in energy as Mg:Ca Ratio Increases\"" > plot.bat
  echo "yaxis label \"Energy of Cell, Relative to Pure MgO & CaO (eV)\"" >> plot.bat
  echo "xaxis label \"Number of Mg atoms Per Unit Cell\"" >> plot.bat
  xmgrace -block rel_energies.dat -bxy 1:3 -batch plot.bat -hardcopy -printfile MgCaRatio.png -hdevice PNG
  sed -i '0,/Mg/{s/Mg/Ca/}' MgO.cell
done
