cmake_minimum_required(VERSION 3.26)
project(MCTDH_analyze Fortran)


enable_language(Fortran)
add_executable(MCTDH_analyze main.f90 norm.f90
               include/daten.f90    include/griddat.f90    include/psidef.f90
        read_psi/rdpsi.f90  read_psi/read_psi_wavefunc.f90
               read_psi/read_psiinfo/rddvrdef.f90  read_psi/read_psiinfo/rdgrddef.f90  read_psi/read_psiinfo/rdpsidef.f90
               read_psi/read_psiinfo/rdpsiinfo.f90
                lib/linear/mmlib.f90  lib/linear/mtlib.f90  lib/linear/op1lib.f90  lib/linear/xvlib.f90)
