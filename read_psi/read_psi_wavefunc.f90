! Created by phyzch on 10/23/23.
subroutine read_psi()
    use daten
    use griddat
    use psidef

    logical lend
    integer i,j, k,  psi_index
    integer psi_info_end  ! file location pointer to record the end of psi_info from the beginning.
    real time , dt



    complex(kind=selected_real_kind(15, 307)) :: spsi(dgldim)  ! this is equivalent to complex * 8 in fortran 77.

    complex(kind=selected_real_kind(33, 4931)) :: psi(dgldim)  ! this is equivalent to the complex * 16 in fortran 77.

    ! output time for wave function in fs.
    dt = out2 / fs

    ! open psi file to read.
    ! See /note/output.html for the info in Psi File.
    ! form = 'unformatted' means the psi file is the binary file.
    ! psi_filename is defined in daten. And it is given in the main program
    open(ipsi, file = psi_filename, form = 'unformatted', status = 'old', ACTION = 'READ')

    ! read version of the file.
    read(ipsi) filever

    ! read information for psi wave function.
    call rdpsiinfo(ipsi)

    !----------------- calculate the # of time steps by reading to the end of the psi file  START -------------------------
    psi_info_end = ftell(ipsi)

    ! for psi_number
    psi_index = 0

    lend = .false.  ! when lend = true, this means we reach the end of the psi file.
                    ! lend is changed in rdpsi function
                    ! in such case, we will exit the do loop below.
    do
        call rdpsi(ipsi, lend)  ! read psi function. The result is stored in psi file.

        ! compute psi_number
        psi_index = psi_index + 1
        if (lend == .true. )
            exit
        end if
    end do
    psi_number = psi_index
    !----------------- calculate the # of time steps by reading to the end of the psi file  END --------------------------

    allocate( psi_array(dgldim,psi_number) )  ! allocate space for psi_array

    allocate(time_list(psi_number))

    ! revert to the location at the end of psi info section.
    call fseek(ipsi, psi_info_end, 0)

    !---------------------- read the wave function psi and store it in the psi_array START -------------
    lend = .false.  ! when lend = true, this means we reach the end of the psi file.
    ! lend is changed in rdpsi function
    ! in such case, we will exit the do loop below.

    psi_index = 1
    time = tinit

    do
        call rdpsi(ipsi, lend)  ! read psi function. The result is stored in psi file

        ! now put the 1d array psi in the psi_array
        do i = 1, dgldim
            psi_array(i, psi_index) = psi(i)
        end do
        time_list(psi_index) = time
        time = time + dt

        psi_index = psi_index + 1
        if (lend == .true.)
            exit
        end if

    end do
    !---------------------- read the wave function psi and store it in the psi array END ---------------

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