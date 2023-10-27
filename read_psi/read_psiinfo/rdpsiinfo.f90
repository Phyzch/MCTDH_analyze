! Created by phyzch on 10/23/23.
! read definition information for psi: wave function.
! This code is based on rdpsiinfo subroutine in /source/mctdh/iofile.F in MCTDH source code.
subroutine rdpsiinfo(unit)
    use daten
    use griddat
    use psidef

    implicit none

    integer n
    integer nopt, ilpsiopt(1 : npsiopt)
    integer unit

    call rddvrdef(unit)  ! read dvr info.
    ! note dvrdat subroutine in rddvrdef calculate the related pointer.
    ! See dvrdat subroutine in iodvrdef.F in MCTDH source code for more information.
    call rdgrddef(unit)  ! read grid definition.
    ! note grddat subroutine in rdgrddef calculate the related pointer.
    ! See grddat subroutine in iogrddef.F in MCTDH source code for more information.
    call rdpsidef(unit)  ! read wave function psi definition.
    ! note psidat subroutine in rdpsidef calculate the related pointer.
    ! See psidat subroutine in iopsidef.F in MCTDH source code for more information.


    ! read  nopt, lpsiopt
    read(unit) nopt, (ilpsiopt(n), n = 1, nopt)  ! nopt: # of options
                                                 ! lpsiopt: options to indicate psi wave function data.
                                                 ! See rdpsi subroutine for details


    if (nopt .lt. 0 .or.  nopt .gt. npsiopt) goto 981

    do n = 1, nopt
        lpsiopt(n) = int2log(ilpsiopt(n))
    end do

    ! read initial time : tinit, frequency of wave function output: out2
    read(unit, err = 981) tinit, out2

    return
    ! ------ error message handling -------------
981  if(nopt.lt.0 .or. nopt.gt.npsiopt) then
     write(6,'(/a,i3,2x,a)') 'Channel:',unit,'Is this a psi-file? Could be a restart file.'
     endif

    routine='rdpsiinfo'
    message='ERROR reading psi file.'
    write(*,*) "routine : " // routine
    write(*,*) "message : " // message

    stop 1
    ! ----- error message handling -------------------------

end subroutine rdpsiinfo