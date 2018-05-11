program makestats
  implicit none
  integer, parameter                        :: dp=selected_real_kind(15,300)
  real (kind=dp)                            :: final_energy, Xx_energy, Yy_energy
  integer                                   :: ios, i, metalnum
  character(len=2)                          :: metal1, metal2, num_string
  character(len=10)                         :: i_string, j_string
  character(len=1024)                       :: filename1, filename2

  read*, metal1
  read*, metal2
  read*, metalnum
  read*, num_string

  open(unit=21, file="rel_energies.dat", iostat=ios, position='append')
  if (ios /= 0) stop "Error opening file 21"

  filename1=metal1//trim(num_string)//metal2//"0O"//trim(num_string)//"/finalenergy.dat"
  filename2=metal1//"0"//metal2//trim(num_string)//"O"//trim(num_string)//"/finalenergy.dat"
  !OPEN FINAL ENERGIES FOR PURE MATERIALS
  open(unit=11,file=trim(filename1), status="old", action="read", iostat=ios)
  if (ios /= 0) stop "Error opening file 11"
  open(unit=12, file=trim(filename2), status="old", action="read", iostat=ios)
  if (ios /= 0) stop "Error opening file 12"

  !READ FINAL ENERGIES FOR PURE MATERIALS
  read(11,*,iostat=ios) Xx_energy
  if (ios /= 0) stop "Error reading file 11"
  read(12,*,iostat=ios) Yy_energy
  if (ios /= 0) stop "Error reading file 11"

  write(21,*) metalnum, 0, 0.0_dp

  close(unit=11, iostat=ios)
  if ( ios /= 0 ) stop "Error closing file unit 11"
  close(unit=12, iostat=ios)
  if ( ios /= 0 ) stop "Error closing file unit 21"

  do i=1,metalnum-1
    write (j_string,'(I0)') metalnum-i
    write (i_string,'(I0)') i
    filename1=metal1//trim(j_string)//metal2//trim(i_string)//"O"//trim(num_string)//"/finalenergy.dat"
    open(unit=11, file=trim(filename1), status="old", action="read", iostat=ios)
    if (ios /= 0) stop "Error opening file 11"

    read(11,*,iostat=ios) final_energy
    if (ios /= 0) stop "Error reading file 11"

    write(21,*) metalnum-i, i, final_energy - (1.0_dp*(metalnum-i)/metalnum)*Xx_energy - (1.0_dp*i/metalnum)*Yy_energy

    close(unit=11, iostat=ios)
    if ( ios /= 0 ) stop "Error closing file unit 11"
  enddo

  write(21,*) 0, metalnum, 0.0_dp


  close(unit=21, iostat=ios)
  if ( ios /= 0 ) stop "Error closing file unit 21"
end program makestats
