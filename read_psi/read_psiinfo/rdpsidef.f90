! See iopsidef.F in MCTDH source code.
! wrpsidef(unit) there write the psi definition.
! rdpsidef(unit, check) there read the psi definition.

subroutine rdpsidef(unit)
    use psidef
    use griddat
    use daten

    integer dentype1
    integer s, m, f, i, j
    integer unit

    read(unit) dentype1
    read(unit) nmode, nstate, npacket, npackts  ! here nstate is # of states. if we do not propagate multiple states, (lmult=false) nstate = 1.
    !  we do not need npacket & npackts.

    allocate( dim(nmode, nstate) )

    do s = 1, nstate
        read(unit) (dim(m,s), m=1, nmode)
    end do

    read(unit) psitype

    if(psitype == 3) then
        ! multi-layer MCTDH wave function.
        ! we do not support such mode now.
        routine='rdpsidef'
        message='ERROR reading psi def file.'
        write(*,*) "routine : " // routine
        write(*,*) "message : " // message

        stop 2
    end if

    ! not sure what are variables below for. just read them in.
    read(unit) citype

    allocate(msymmtr(2*nmode), idmode(nmode), symcv(nmode))

    read(unit) (msymmtr(m), m = 1, 2 * nmode)
    read(unit) (idmode(m), m = 1, nmode)
    read(unit) (symcv(m), m = 1, nmode)

    call psidat




end subroutine rdpsidef


! see iopsidef.F psidat subroutine.
! allocate pointer for wave function tensor.
subroutine psidat
    use daten
    use psidef
    use griddat

    implicit none

    integer m, s, zeig, e

    !-----------------------------------------------------------------------
    ! calculate dim,vdim and block(s) for each mode.
    ! dim(m,s): read from rdpsidef, the # of single particle functions in the mode m for state s.
    ! vdim: cumulative number of single particle functions for preceding modes.
    ! ndim: cumulative number of single particle functions for following modes.
    ! block(s) : total length of the A coefficient tensor for state s.
    ! size of block (number of MCTDH coefficients)
    !-----------------------------------------------------------------------

    allocate(vdim(nmode, nstate), ndim(nmode, nstate))
    allocate( block(nstate) ) ! size of A coefficient tensor for diff states.
    allocate( zpsi(nstate) ) ! pointer for A vectors for state s.
    allocate( phidim(nmode) ) ! size of basis sets for mode m.
    allocate( zetf(nmode, nstate) ) ! pointer for single particle functions.


    do s = 1, nstate
        if (psitype .eq. 3)then
            routine='psidat'
            message='ERROR we do not support Multi-layer MCTDH.'
            write(*,*) "routine : " // routine
            write(*,*) "message : " // message
            stop 3
        else
            zeig = 1

            ! compute vdim(m,s)
            do m = 1, nmode
                vdim(m,s) = zeig
                zeig = zeig * dim(m,s)
            end do
            ! length of A coefficient tensor.
            block(s) = zeig

            ! compute ndim(m,s)
            do m=1, nmode
                ndim(m,s) = block(s) / (dim(m,s) * vdim(m,s))
            end do

        end if
    end do


    ! compute maxblock : maximum block across all state s
    do s=1,nstate
        maxblock=max(maxblock,block(s))
    enddo

    !-----------------------------
    ! compute zpsi(s): pointer for A coefficient tensor for state s.
    ! compute adim: total length of A coefficient tensor for all state s. adim = sum[block(s)]
    !-----------------------------
    zeig = 1
    do s=1, nstate
        zpsi(s) = zeig
        zeig = zeig + block(s)
    end do
    adim = zeig - 1

    !-------------------------------------------
    ! compute phidim(m): the length of spf vectors for mode m.
    ! compute the length of single particle function arrays
    !-----------------------------------------
    totphidim = 0
    call zerovxi(phidim, nmode)
    do m = 1, nmode
        phidim(m) = 0
        if(idmode(m) .eq. 0) then
            do s = 1, nstate
                phidim(m) = phidim(m) + subdim(m) * dim(m,s)
            end do
        end if
        totphidim = totphidim + phidim(m)
    end do
    maxphidim = maxval(phidim)

    !------------------------------------------------------
    ! compute zetf(m,s) point to spfs for mode m in state s
    !-------------------------------------------------------
    zeig = adim + 1
    do m = 1, nmode
        if(idmode(m) .eq. 0) then
            do s = 1, nstate
                zetf(m,s) = zeig
                zeig = zeig + subdim(m) * dim(m,s)
            end do
        else
            do s = 1, nstate
                zetf(m,s) = zetf(idmode(m), s)
            end do
        end if
    end do
    ! dgldim : total length of wave function array contains tensor coefficients A and single particle functions (spfs)
    dgldim = zeig - 1

    !---------------------------------------------
    ! pointers and size for density matrices.
    ! be careful, the alignment would be first with index s (state), then with index m (mode)
    ! dmat(m,s) here is the pointer for the density matrix. (I think dmat here represents denstiy matrix)
    !---------------------------------------
    zeig = 1
    do s = 1, nstate
        do m = 1, nmode
            if(idmode(m) .eq. 0) then
                dmat(m,s) = zeig
                zeig = zeig + dim(m,s)**2
            else
                dmat(m,s) = dmat(idmode(m), s)
            end if
        end do
    end do
    dmatdim = zeig - 1

    !---------------------------------------------------
    ! compute maximum number of single-particle functions
    !---------------------------------------------------
    maxspf = 0
    do s = 1, nstate
        do m = 1, nmode
            maxspf = max(maxspf, dim(m,s))
        end do
    end do

end subroutine psidat