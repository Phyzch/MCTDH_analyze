! Created by phyzch on 10/26/23.

! See rdpsi subroutine in rdfiles.F in MCTDH code.
! unit: unit for psi file. used for reading wave function.
! lend: indicate wheter we reach the end of the psi file
subroutine rdpsi(unit, lend)
    use daten
    use psidef
    use griddat

    complex(kind=selected_real_kind(15, 307)) :: spsi(dgldim)  ! this is equivalent to complex * 8 in fortran 77.
    complex(kind=selected_real_kind(33, 4931)) :: psi(dgldim)  ! this is equivalent to the complex * 16 in fortran 77.
    logical    lpsisp,lpsicm,lerr,lselect
    integer    m,s, dgl

    integer unit
    logical lend

    lend = .false.
    ! ---------------------------------
    !     variables below indicate how psi is saved.
    !     lpsinat  : psi saved as natural orbitals
    !     lpsicm   : psi saved in compact form
    !     lpsisp   : psi saved in single precision
    !     lselect: selected CI. (not supported)
    ! ---------------------------------
    lpsisp = lpsiopt(1)
    lpsicm = lpsiopt(2)
    lselect = lpsiopt(4)
    lerr = .true.

    ! the code below is quite funny. most options is not supported for psi file.
    if (lpsicm) then
        routine = 'rdpsi'
        message = 'psi in compact form is not supported'
        write(*,*) "routine" // routine
        write(*,*) "error message: " // message
        stop 4
    else if (lselect) then
        routine = "rdpsi"
        message = "Selected CI for psi file is not supported"
        write(*,*) "routine" // routine
        write(*,*) "error message: " // message
        stop 4
    end if

    ! read wave function
    ! see psiouot.F line 135 in MCTDH source code
    if(lpsisp) then    ! lpsisp: single precision for psi
        read(unit, end = 10, err = 30) (spsi(dgl), dgl = 1, dgldim)

        do dgl = 1, dgldim
            psi(dgl) = spsi(dgl)
        end do

    else   ! not lpsisp: double precision for psi
        read(unit, end = 10, err = 30) (psi(dgl), dgl = 1, dgldim)
    end if


    return   ! not the end of the file. return.

    10 lend = .true.   ! end of the file
    return  ! return, end of the file

    ! error handling
    30  write(*,*) "ERROR in rdpsi (rdpsi.f90)"
        write(*,*) "when reading element index : dgl = ", dgl, ",  dgldim = ", dgldim
        write(*,*) "lpsisp : " , lpsisp
        stop 4

end subroutine rdpsi

