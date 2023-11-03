
program MCTDH_analyze
    use daten
    ! the folder path that psi file locates
    psi_folderpath = "/home/phyzch/MCTDH_main/tutorial/nocl/nocl1/"

    ! the file path of psi file
    psi_filename = psi_folderpath // "psi"

    ! the folder location that the output of analysis of psi file reside.
    output_folderpath = "/home/phyzch/Presentation/MCTDH_analyze_output/try/"

    ! the norm function. this is adapted from analyse/norm.F code in MCTDH source code.
    ! compute norm of wave function and tensor array A.
    call norm()

end program
