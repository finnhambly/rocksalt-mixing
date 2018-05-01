program makecell
  implicit none
  integer, parameter                        :: dp=selected_real_kind(15,300)
  real (kind=dp)                            :: final_energy
  integer                                   :: ios, i, j, ierr, Ca_num, Mg_num
  character(len=1)                          :: num_string
  character(len=30)                         :: line
  real (kind=dp), dimension(:), allocatable :: all_temps

  ! print*, "Provide the temperature set in the equilibrium phase"
  read*, Mg_num
  read*, Ca_num

  write(num_string,'(I1)') Mg_num

  open(unit=11, file="Mg"//num_string//"/finalenergy.dat", status="old", action="read", iostat=ios)
  if (ios /= 0) stop "Error opening file 11"
  open(unit=12, file="Mg"//num_string//"/MgO.castep", status="old", action="read", iostat=ios)
  if (ios /= 0) stop "Error opening file 12"
  open(unit=21, file="energies.dat", iostat=ios, position='append')
  if (ios /= 0) stop "Error opening file 21"

  do i=1,2
    read(11,*,iostat=ios)
    if (ios /= 0) stop "Error reading from file 11"
  enddo

  read(11,*,iostat=ios) line, line, line, line, final_energy
  if (ios /= 0) stop "Error reading file 11"

!  write(21,*) "      # of Mg     # of Ca             E  "
  write(21,*) Mg_num, Ca_num, " ", final_energy

  close(unit=11, iostat=ios)
  if ( ios /= 0 ) stop "Error closing file unit 11"

  close(unit=12, iostat=ios)
  if ( ios /= 0 ) stop "Error closing file unit 12"

  close(unit=21, iostat=ios)
  if ( ios /= 0 ) stop "Error closing file unit 21"

end program makecell
