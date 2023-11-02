! Created by phyzch on 10/23/23.
! contain information about input / output control options & time variables.
module daten
    ! program version
    real filever

    Character( len = : ), allocatable :: psi_filename
    Character( len = : ), allocatable :: psi_folderpath

    Character( len = : ), allocatable :: output_folderpath

    ! for error information handling.
    Character( len = : ), allocatable :: routine
    Character( len = : ), allocatable :: message

    integer ipsi
    !--------------------------------------
    ! TIME VARIABLES
    !
    !  out1:       Frequency of data output in fs
    !  out2:       Frequency of wavefunction output in fs
    !  tfinal:     Final time in fs
    !  tinit:      Time at start of calculation in fs
    !----------------------------------------
    real*8 out1, out2, tfinal, tinit
    parameter (fs = 41.3414d0)  ! See doc/mctdh/input.html, section unit for conversion factor for fs.

    !-----------------------------------------------------------------------
    ! LOGICALS TO CONTROL INPUT / OUTPUT OPTIONS
    !
    !     lpsiopt  : options as to how psi is to be saved
    !     this is also stored in psi file.
    !-----------------------------------------------------------------------
    integer, parameter :: npsiopt = 20      ! set it to be large enough so we do not run out of space for nopt.
    logical lpsiopt(npsiopt)

end module daten