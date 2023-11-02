! Created by phyzch on 10/23/23.

! read grid information. This information corresponds to how different grids combined into modes
! there are total ndof grids, and total nmode # of modes.
subroutine rdgrddef(unit)
    use daten
    use griddat

    integer f, i, j, k, m
    integer dentype1
    integer ilmult1, ileb1, ilmulpack1

    integer unit

    ! read dentype1. dentype1 is useless.
    read(unit) dentype1

    read(unit) ndof, nmode

    allocate(nspfdof(nmode))
    allocate(dofspf(ndof))
    allocate(spfdof(ndof, nmode))

    allocate(subdim(nmode)) ! the size of the basis set.

    read(unit) nstate, npacket, npackts, feb, meb, fpb, mpb
    read(unit) (nspfdof(m), m=1,nmode)  ! # of dof for each mode.
    do m=1,nmode
        read(unit) (spfdof(n,m), n=1,nspfdof(m))  ! read grid dof in each single particle function mode.
    end do

    read(unit)(dofspf(f), f=1,ndof) ! read single particle function mode for each dof.

    !read lmult, leb, lmulpack
    read(unit) ilmult1, ileb1, ilmulpack1
    lmult = (ilmult1 /= 0)
    leb = (ileb1 /= 0)
    lmulpack = ( ilmulpack1 /= 0 )

    call griddat_pointer

end subroutine rdgrddef



! calculate the subdim(m) : grid size for mode m.
! calculate vgdim(f), ngdim(f): for the grid dof f in the mode m.
! calculate maximum grid dimension : maxsubdim
subroutine griddat_pointer
    use griddat
    use daten

    implicit none

    integer m,f, zeig, n

    !------------------------------------------------------------------
    ! calculate spf grid dimensions (subdim, vgdim, ngdim) for each mode
    ! subdim(m) is size of grid point for mode m. (contain multiple grid dofs (f))
    ! vgdim(f): product of grid point # with index before given dof f in the same mode m.
    ! ngdim(f): product of grid point # with index after given dof f in the same mode m.
    !------------------------------------------------------------------

    do m = 1, nmode
        zeig = 1
        ! calculate vgdim(f). go through all grid dof (f) within mode m.
        do n = 1, nspfdof(m)
            f = spfdof(n,m)
            vgdim(f) = zeig
            zeig = zeig * gdim(f)
        end do
        ! the size of basis set for mode m is now given by zeig
        subdim(m) = zeig
        ! now compute the ngdim(f)
        do n = 1, nspfdof(m)
            f = spfdof(n,m)
            ngdim(f) = subdim(m) / (gdim(f) * vgdim(f))
        end do
    end do

    ! ---------------------------------
    ! set maximum mode grid dimensons
    ! ---------------------------------
    maxsubdim = 1
    do m = 1, nmode
        maxsubdim = max(maxsubdim, subdim(m))

        !------------
        ! no idea what's funny about basis(f) .eq. 12 (Leg/r), looks like we have to take care of it.
        do n = 1, nspfdof(m)
            f = spfdof(n,m)
            if(basis(f) .eq. 12) then
                maxsubdim = max( maxsubdim, ipbaspar(3,f) * subdim(m) / gdim(f) )
            end if
        end do
        !-------------------
    end do

    ! leb       : set to true if operator contains an electronic basis
    ! feb      : index of degree of freedom described by an electronic basis
    ! meb      : mode of the electronic basis (feb)

    if (leb) then
        meb = dofspf(feb)
        nstate = 1
    end if

    if(lmult .and.  .not. lmulpack) then
        meb = 0
        nstate = gdim(feb)
    end if

end subroutine griddat_pointer