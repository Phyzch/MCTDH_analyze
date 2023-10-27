
program MCTDH_analyze
    use daten
    psi_folderpath = "/home/phyzch/MCTDH_main/tutorial/nocl/nocl1/"

    psi_filename = psi_folderpath // "psi"

    output_folderpath = "/home/phyzch/Presentation/MCTDH_analyze_output/try/"

    call norm()

end program
