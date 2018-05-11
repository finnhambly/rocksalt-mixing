!  =============================== perms.f90 =================================
!
!                        ██████╗    ███████╗   ███╗   ███╗
!                        ██╔══██╗   ██╔════╝   ████╗ ████║
!                        ██████╔╝   ███████╗   ██╔████╔██║
!                        ██╔══██╗   ╚════██║   ██║╚██╔╝██║
!                        ██║  ██║██╗███████║██╗██║ ╚═╝ ██║██╗
!                        ╚═╝  ╚═╝╚═╝╚══════╝╚═╝╚═╝     ╚═╝╚═╝
!
!  ============================================================================
!  This is the Fortran 90 program for writing the metal oxide crystal structure
!  in every unique way, for the rocksalt.sh to subsequently run in CASTEP.
!  This is part of the DFT model.
!  Only 16-atom unit cells are compatible with this program.
!
!! \todo Identical crystal structures will be obtained, remove these to improve
!!  efficiency
!! \todo This should be programmed for any unit cell size, rather than being
!! hardcoded for 16 atom unit cells.
!
!  Written by Finn Hambly and Alex Gregory (2018).
!  ============================================================================

program permutations
  implicit none
  integer, dimension(:), allocatable :: perms
  integer                            :: ierr, i, perm_num, ios, metalnum
  character(len=2)                   :: metal1, metal2

  metalnum=8

  read*, metal1
  read*, metal2
  read*, perm_num

  !allocating an array with each index corresponding to a metal atom in the unit cell
  allocate(perms(metalnum), stat=ierr)
  if (ierr /= 0) print *, "perms(num_of_perms,metalnum): Allocation request denied"

  !opening .cell file to append coordinates for the metal atoms
  open(unit=40, file='MgO.cell', iostat=ios, position='append')
  if ( ios /= 0 ) stop "Error opening file MgO.cell"
  !opening the set of all possible unique orderings of 2 numbers in a list
  open(unit=50, file="perms.dat", status="old", action="read", iostat=ios)
  if (ios /= 0) stop "Error opening file 50"

  !Skip lines until the required permutation is reached
  if (perm_num /= 1) then
    do i=1,perm_num-1
      read(50,*,iostat=ios)
    enddo
  endif

  !read the ordering of the two atom-types for this permutation
  read(50,*,iostat=ios) perms(1), perms(2), perms(3), perms(4), perms(5), perms(6), perms(7), perms(8)
  if ( ios /= 0 ) stop "Read error in file unit 50"

  !write to the cell file, with the current ordering of atom-types set
  if (perms(1)==1) then
    write(40,'(a)') "    "//metal1//"    0.0000000000    0.0000000000    0.0000000000"
  endif
  if (perms(1)==2) then
    write(40,'(a)') "    "//metal2//"    0.0000000000    0.0000000000    0.0000000000"
  endif
  if (perms(2)==1) then
    write(40,'(a)') "    "//metal1//"    0.0000000000    0.5000000000    0.5000000000"
  endif
  if (perms(2)==2) then
    write(40,'(a)') "    "//metal2//"    0.0000000000    0.5000000000    0.5000000000"
  endif
  if (perms(3)==1) then
    write(40,'(a)') "    "//metal1//"    0.2500000000    0.0000000000    0.5000000000"
  endif
  if (perms(3)==2) then
    write(40,'(a)') "    "//metal2//"    0.2500000000    0.0000000000    0.5000000000"
  endif
  if (perms(4)==1) then
    write(40,'(a)') "    "//metal1//"    0.2500000000    0.5000000000    0.0000000000"
  endif
  if (perms(4)==2) then
    write(40,'(a)') "    "//metal2//"    0.2500000000    0.5000000000    0.0000000000"
  endif
  if (perms(5)==1) then
    write(40,'(a)') "    "//metal1//"    0.5000000000    0.0000000000    0.0000000000"
  endif
  if (perms(5)==2) then
    write(40,'(a)') "    "//metal2//"    0.5000000000    0.0000000000    0.0000000000"
  endif
  if (perms(6)==1) then
    write(40,'(a)') "    "//metal1//"    0.5000000000    0.5000000000    0.5000000000"
  endif
  if (perms(6)==2) then
    write(40,'(a)') "    "//metal2//"    0.5000000000    0.5000000000    0.5000000000"
  endif
  if (perms(7)==1) then
    write(40,'(a)') "    "//metal1//"    0.7500000000    0.0000000000    0.5000000000"
  endif
  if (perms(7)==2) then
    write(40,'(a)') "    "//metal2//"    0.7500000000    0.0000000000    0.5000000000"
  endif
  if (perms(8)==1) then
    write(40,'(a)') "    "//metal1//"    0.7500000000    0.5000000000    0.0000000000"
  endif
  if (perms(8)==2) then
    write(40,'(a)') "    "//metal2//"    0.7500000000    0.5000000000    0.0000000000"
  endif

  !close files
  close(unit=40, iostat=ios)
  if ( ios /= 0 ) stop "Error closing file unit 40"
  close(unit=50, iostat=ios)
  if ( ios /= 0 ) stop "Error closing file unit 50"

end program
