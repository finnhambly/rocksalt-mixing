program cell
  implicit none
  integer, parameter :: dp=selected_real_kind(15,300)
  integer            :: n, maxpos, i, ierr

  type vsltype
    character(len=:), allocatable :: s
  end type vsltype

  type(vsltype), dimension(:), allocatable :: positions

  n=8         ! n is number of atoms in cell - must be divisible by 2
  maxpos=n/2  ! assume oygen atoms fixed atoms fixed

  allocate(positions(maxpos),stat=ierr)
  if (ierr.ne.0) stop 'error allocating positions array'

  do i=1,maxpos
    if (mod(i,2).ne.0) then
      positions(i)%s='Mg'
    else
      positions(i)%s='Ca'
    end if
  end do

  !test
  if (positions(1)%s.eq.'Mg') then
    print*, 'check'
  end if

  open(50,file='test')
  write(50,"(a)") '%BLOCK POSITIONS_FRAC'
  do i=1,maxpos
    write(50,*) '   ', positions(i)%s
  end do
  write(50,"(a)") '%ENDBLOCK POSITIONS_FRAC'
  close(50)

  deallocate(positions,stat=ierr)
  if (ierr.ne.0) stop 'error deallocating positions array'

end program cell
