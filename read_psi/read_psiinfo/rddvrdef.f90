! Created by phyzch on 10/23/23.

! dvr definition is the information for discrete variable representation (DVR) along each grid dof.
! in MCTDH program, along each grid dof, the basis set of such grid is given by dvr.
! basis(f) decide the type of dvr chosen for each grid dof. See einpbas.F for which dvr the integer value of basis(f) represents

subroutine rddvrdef(unit)
    use daten
    use griddat
    integer f, i, j, k, n
    integer , parameter :: maxdim = 50  ! maximum # of dof.
    integer , allocatable :: ildvr(:)
    read(unit) ndof  ! read ndof

    ! error handling. if ndof is too large, there could be error in reading the file
    if (ndof .gt. maxdim) then
        routine='rddvrdef'
        message='ERROR reading psi file. dvr definition'
        write(*,*) "routine : " // routine
        write(*,*) "message : " // message

        stop 2
    end if

    allocate (modelabel(ndof))
    allocate (gdim(ndof))

    ! read modelabel and gdim
    read(unit) (modelabel(f), f = 1, ndof)
    read(unit) (gdim(f), f = 1, ndof)

    ! read mbaspar : maximum number of parameters used to define bases
    read(unit) mbaspar

    allocate (basis(ndof))
    allocate (ildvr(ndof) , ldvr(ndof))

    allocate(ipbaspar(mbaspar, ndof) , rpbaspar(mbaspar, ndof), xend(mbaspar, ndof))

    ! read basis
    read(unit) (basis(f), f= 1, ndof)
    ! here ildvr : integer form of ldvr. We store integer form of logical variable in psi file.
    read(unit) (ildvr(f), f= 1, ndof)

    do f = 1, ndof
        ldvr(f) = int2log(ildvr(f))
    end do

    ! read ipbaspar : integer parameters needed to define primitive basis
    read(unit) ((ipbaspar(i,f), i=1,mbaspar),f=1,ndof)
    ! read rpbaspar : real parameters needed to define primitive basis
    read(unit)((rpbaspar(i,f), i=1,mbaspar), f=1,ndof)

    ! read xend. Don't know what this variable is for. pretty useless
    read(unit)((xend(i,f), i=1,mbaspar), f=1,ndof)

    !
    call dvrdat



end subroutine rddvrdef




subroutine dvrdat
    ! find grid dof (basis) that represents electronic dof.
    ! find grid dof which is represented by dvr (ldvr)
    ! find maximum size of grid point maxgdim
    use daten
    use griddat
    implicit none

    integer f

    ! basis(f) : basis type for dof f. (dof=degree of freedom)
    !     (0,1,2,3,4,5,6,7,8,9)->(el,HO,Leg,sin,FFT,exp,sphfbr,kleg,k,pleg)
    !     (-1,11,12,13) -> blank basis (phifbr), rHO, Leg/r, external-DVR
    !     (14,15,16,17,18) -> cos, Lagu1, Lagu2, Lagu3, Lagu4
    !     (19) -> wigner
    ! See einpbas.F in MCTDH program.
    do f=ndof, 1, -1
        if (basis(f) .eq. 0) feb = f  ! find the dof that corresponds to electronic dof.
    end do

    ! figure out wether the grid dof use discrete variable representation (DVR)
    do f=1, ndof
        if (basis(f) .le. 0 .or. basis(f) .eq. 4 .or. basis(f) .eq. 6) then
            ldvr(f)=.false.
        else
            ldvr(f) = .true.
        end if
    end do

    ! compute maximum grid dimension size : maxgdim.
    maxgdim = 1
    do f = 1, ndof
        maxgdim = max( maxgdim, gdim(f) )
        if(basis(f) .eq. 12) then
            maxgdim = max(maxgdim, ipbaspar(3,f))  ! no idea what this is for, copied from source code.
        end if
    end do
    maxgdim2 = maxgdim ** 2

end subroutine dvrdat