! Created by phyzch on 10/23/23.
subroutine read_psi()
    use daten
    use griddat
    use psidef

    logical lend
    integer i,j, k,  psi_index

    real time , dt


    ! open psi file to read.
    ! See /note/output.html for the info in Psi File.
    ! form = 'unformatted' means the psi file is the binary file.
    ! psi_filename is defined in daten. And it is given in the main program
    open(ipsi, file = psi_filename, form = 'unformatted', status = 'old', ACTION = 'READ')

    ! read version of the file.
    read(ipsi) filever

    ! read header information for psi wave function.
    call rdpsiinfo(ipsi)

    ! allocate space for wave function psi. dgldim: total length of wave function psi.
    allocate(spsi(dgldim), psi(dgldim))

    ! output time for wave function in fs.
    ! See doc/mctdh/input.html, section unit for unit of fs.
    dt = out2 / fs

    ! for recording time step.
    psi_index = 1
    time = tinit

    allocate( psi_array(dgldim,psi_number_max) )  ! allocate space for psi_array

    allocate(time_list(psi_number_max))  ! allocate space for the time.


    lend = .false.  ! when lend = true, this means we reach the end of the psi file.
                    ! lend is changed in rdpsi function
                    ! in such case, we will exit the do loop below.
    do
        call rdpsi(ipsi, lend)  ! read psi function. The result is stored in psi file.
        ! now put the 1d array psi in the psi_array
        do i = 1, dgldim
            psi_array(i, psi_index) = psi(i)
        end do
        time_list(psi_index) = time
        time = time + dt

        if (lend .eqv. .true. ) then
            exit
        end if
        ! compute psi_number
        psi_index = psi_index + 1

        if (psi_index .gt. (psi_number_max+1) ) then
            routine = 'read_psi'
            message = 'psi file length is longer than psi_number_max '
            stop 6
        end if

    end do
    psi_number = psi_index - 1
    !----------------- calculate the # of time steps by reading to the end of the psi file  END --------------------------

    ! close the psi file.
    close(ipsi)
end subroutine read_psi



subroutine deallocate_psi()
    ! deallocate the variable for wave function psi
    use psidef
    use griddat
    use daten

    deallocate(psi_array)
    deallocate(time_list)

end subroutine deallocate_psi