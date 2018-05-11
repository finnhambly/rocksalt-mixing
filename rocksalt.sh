#!/bin/bash

# ============================== rocksalt.sh ===================================
#
#                       ██████╗    ███████╗   ███╗   ███╗
#                       ██╔══██╗   ██╔════╝   ████╗ ████║
#                       ██████╔╝   ███████╗   ██╔████╔██║
#                       ██╔══██╗   ╚════██║   ██║╚██╔╝██║
#                       ██║  ██║██╗███████║██╗██║ ╚═╝ ██║██╗
#                       ╚═╝  ╚═╝╚═╝╚══════╝╚═╝╚═╝     ╚═╝╚═╝
#
# ==============================================================================
# This is the main RSM script, which provides the command line interface for
# running either the DFT or atomistic model for analysing metal oxide mixing.
#
# Written by Finn Hambly and Alex Gregory (2018).
# ==============================================================================

#READ ANALYSIS METHOD TO BE USED
echo "This program calculates the properties of rocksalt structures."
echo "There are two models available for testing:"
echo "1) a density functional theory model implemented with CASTEP, or"
echo "2) an atomistic model, based on the Lennard-Jones potential."
echo " "
valid=0 #measures the validity of user input: 0 corresponds with invalid
while [ $valid -ne 1 ] ; do
  read -p "Would you like to use model 1 or 2?" method
  if [ $method -eq 1 ]
  then
    echo "DFT model chosen."
    valid=1 #implying the user input is valid
  elif [ $method -eq 2 ]
  then
    echo "Atomistic model chosen."
    valid=1
  else
     echo " "
     echo "Invalid response."
   fi
done

#READ WHETHER METAL1:METAL2 RATIO OR METAL ARRANGEMENT IS OF INTEREST
if [ $method -eq 1 ] #only ask about task if method 1 has been selected
then
  valid=0
  while [ $valid -ne 1 ] ; do
    echo "Are you interested in comparing:"
    echo "1) the ratios of group 2 metals in a cubic crystal system, or"
    echo "2) the arrangements of group 2 metals in a cubic crystal system?"
    read task;
    if [ $task -eq 1 ] || [ $task -eq 2 ]
    then
      valid=1
    else
      echo " "
      echo "Invalid response."
    fi
   done
 fi

#READ METALS TO TEST
read -p "What is the first alkaline metal would you like to test?" metal1
read -p "What is the second alkaline metal would you like to test?" metal2

#IF TESTING FOR RATIOS - UNIT CELL SIZE OF 8 OR 16?
valid=0
if [ $task -eq 1 ]
then
  while [ $valid -ne 1 ] ; do
    read -p "Would you like to test a unit cell with 8 or 16 atoms? (8/16)" unitcell
    if [ $unitcell -eq 8 ] || [ $unitcell -eq 16 ]
    then
      valid=1
    else
      echo " "
      echo "Invalid response."
    fi
   done
elif [ $task -eq 2 ]
then
 unitcell=16
fi

#WRITE THE PARAMETER FILE
./writeparam.sh

#WRITE THE CELL FILE FOR 16-ATOM UNIT CELL
if [ $unitcell -eq 16 ]
then
cat > MgO.cell <<EOL
%BLOCK LATTICE_CART
    8.4000000000    0.0000000000    0.0000000000
    0.0000000000    4.2000000000    0.0000000000
    0.0000000000    0.0000000000    4.2000000000
%ENDBLOCK LATTICE_CART

%BLOCK POSITIONS_FRAC
     O    0.2500000000    0.5000000000    0.5000000000
     O    0.2500000000    0.0000000000    0.0000000000
     O    0.0000000000    0.5000000000    0.0000000000
     O    0.0000000000    0.0000000000    0.5000000000
     O    0.5000000000    0.5000000000    0.0000000000
     O    0.5000000000    0.0000000000    0.5000000000
     O    0.7500000000    0.0000000000    0.0000000000
     O    0.7500000000    0.5000000000    0.5000000000
    ${metal1}    0.0000000000    0.0000000000    0.0000000000
    ${metal1}    0.0000000000    0.5000000000    0.5000000000
    ${metal1}    0.2500000000    0.0000000000    0.5000000000
    ${metal1}    0.2500000000    0.5000000000    0.0000000000
    ${metal1}    0.5000000000    0.0000000000    0.0000000000
    ${metal1}    0.5000000000    0.5000000000    0.5000000000
    ${metal1}    0.7500000000    0.0000000000    0.5000000000
    ${metal1}    0.7500000000    0.5000000000    0.0000000000
%ENDBLOCK POSITIONS_FRAC

kpoints_mp_spacing 0.05952381

symmetry_generate

%BLOCK CELL_CONSTRAINTS
       1       1       1
       0       0       0
%ENDBLOCK CELL_CONSTRAINTS

! The following section is commented out; CASTEP will generate these files for you
! the first time you use the appropriate element. You can then uncomment this block
! to speed up the initial stages of the calculation.
!%BLOCK SPECIES_POT
!       O   O_C18_LDA_OTF.usp
!      ${metal1}  ${metal1}_C18_LDA_OTF.usp
!      ${metal2}  ${metal2}_C18_LDA_OTF.usp
!%ENDBLOCK SPECIES_POT
EOL

#WRITE THE CELL FILE FOR 8-ATOM UNIT CELL
elif [ $unitcell -eq 8 ]
then
cat > MgO.cell<<EOL
%BLOCK LATTICE_CART
    4.2000000000    0.0000000000    0.0000000000
    0.0000000000    4.2000000000    0.0000000000
    0.0000000000    0.0000000000    4.2000000000
%ENDBLOCK LATTICE_CART

%BLOCK POSITIONS_FRAC
     O    0.5000000000    0.5000000000    0.5000000000
     O    0.5000000000    0.0000000000    0.0000000000
     O    0.0000000000    0.5000000000    0.0000000000
     O    0.0000000000    0.0000000000    0.5000000000
    ${metal1}    0.0000000000    0.0000000000    0.0000000000
    ${metal1}    0.0000000000    0.5000000000    0.5000000000
    ${metal1}    0.5000000000    0.0000000000    0.5000000000
    ${metal1}    0.5000000000    0.5000000000    0.0000000000
%ENDBLOCK POSITIONS_FRAC

kpoints_mp_grid 4 4 4

symmetry_generate

%BLOCK CELL_CONSTRAINTS
       1       1       1
       0       0       0
%ENDBLOCK CELL_CONSTRAINTS

! The following section is commented out; CASTEP will generate these files for you
! the first time you use the appropriate element. You can then uncomment this block
! to speed up the initial stages of the calculation.
!%BLOCK SPECIES_POT
!       O   O_C18_LDA_OTF.usp
!      ${metal1}  ${metal1}_C18_LDA_OTF.usp
!      ${metal2}  ${metal2}_C18_LDA_OTF.usp
!%ENDBLOCK SPECIES_POT
EOL
fi

#FIND THE RELATIVE ENERGY FOR RATIO OF METAL1:METAL2 WHEN MIXED
if [ $task -eq 1 ]
then
  >finalenergy.dat
  >rel_energies.dat
  gfortran makestats.f90 -o makestats
  Yy=0
  metalnum=$(($unitcell/2))
  while [ $Yy -le $metalnum ] ; do
    Xx=$(($metalnum-$Yy))
    newdir=${metal1}${Xx}${metal2}${Yy}O${metalnum}
    # mkdir -p ${newdir}
    # time mpirun -np 4 ./castep.mpi MgO
    # mv -u MgO.castep ${newdir}
    grep "Final energy" ${newdir}/MgO.castep | tail -1 | awk '{print $5}' > ${newdir}/finalenergy.dat
    sed -i '0,/'${metal1}'/{s/'${metal1}'/'${metal2}'/}' MgO.cell
    Yy=$(($Yy+1))
  done

  #FIND ENERGIES OF EACH STRUCTURE RELATIVE TO PURE CRYSTALS
  echo ${metal1} > read.in
  echo ${metal2} >> read.in
  echo ${metalnum} >> read.in
  echo ${metalnum} >> read.in
  ./makestats < read.in

  echo "title \"Change in Energy as "$metal2":"$metal1" Ratio Increases\"" > plot.bat
  echo "yaxis label \"Energy of Cell, Relative to Non-Mixed Compounds (eV)\"" >> plot.bat
  echo "xaxis label \"Number of "$metal2" Atoms Per Unit Cell\"" >> plot.bat
  xmgrace -block rel_energies.dat -bxy 1:3 -batch plot.bat -hardcopy -printfile MgCaRatio.png -hdevice PNG
fi

max_energy=0.0
#FIND THE LOWEST ENERGY CONFIGURATION OF METAL1 AND METAL2 IN CRYSTAL
if [ $task -eq 2 ]
then
  gfortran perms.f90 -o perms
  for i in {0..70}; do
    mkdir -p permutations/$i
    cat > MgO.cell <<EOL
%BLOCK LATTICE_CART
    8.4000000000    0.0000000000    0.0000000000
    0.0000000000    4.2000000000    0.0000000000
    0.0000000000    0.0000000000    4.2000000000
%ENDBLOCK LATTICE_CART

%BLOCK POSITIONS_FRAC
     O    0.2500000000    0.5000000000    0.5000000000
     O    0.2500000000    0.0000000000    0.0000000000
     O    0.0000000000    0.5000000000    0.0000000000
     O    0.0000000000    0.0000000000    0.5000000000
     O    0.5000000000    0.5000000000    0.0000000000
     O    0.5000000000    0.0000000000    0.5000000000
     O    0.7500000000    0.0000000000    0.0000000000
     O    0.7500000000    0.5000000000    0.5000000000
EOL
    echo $metal1 > read.in
    echo $metal2 >> read.in
    echo $i >> read.in
    ./perms < read.in
    cat >> MgO.cell <<EOL
%ENDBLOCK POSITIONS_FRAC

kpoints_mp_spacing 0.05952381

symmetry_generate

%BLOCK CELL_CONSTRAINTS
       1       1       1
       0       0       0
%ENDBLOCK CELL_CONSTRAINTS

! The following section is commented out; CASTEP will generate these files for you
! the first time you use the appropriate element. You can then uncomment this block
! to speed up the initial stages of the calculation.
!%BLOCK SPECIES_POT
!       O   O_C18_LDA_OTF.usp
!      ${metal1}  ${metal1}_C18_LDA_OTF.usp
!      ${metal2}  ${metal2}_C18_LDA_OTF.usp
!%ENDBLOCK SPECIES_POT
EOL
    time mpirun -np 4 ./castep.mpi MgO
    mv -u MgO.castep permutations/$i
    mv -u MgO.cell permutations/$i
    energy="$(grep "Final energy" permutations/$i/MgO.castep | tail -1 | awk '{print $5}')"
    echo $energy > permutations/$i/finalenergy.dat
    if (( $(echo "$energy $max_energy" | awk '{print ($1 < $2)}') ))
    then
      max_energy=$energy
      best_perm=$i
    fi
  done
echo "The lowest energy crystal structure can be found in permutation "$best_perm
./src/jmol-14.29.13/jmol.sh permutations/${i}/MgO.cell &
fi

#delete redundant files
rm *.bat read.in
