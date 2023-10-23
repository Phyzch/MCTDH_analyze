# Write code to analyze MCTDH algorithm output psi file



## File structure



We should write :

* a file to read data definition : dvrdef (rddvr), griddef (rdgrid), psidef (rdpsidef).

The main function for all these information is rdpsiinfo.f90



* a file to read psi data itself ( rdpsi.f90)



* a file that compute size of blocks & vdim, ndim, dim (dimension for multi-dimensional single particle function (spfs)) for each mode. (psidat.f90)



* one file or several files  that include all variables I need to claim and share between files. This should be included in the ''module" for sharing variables. 
  
  (See daten.inc, griddat.inc and psidef.inc)

    

        Here daten.inc is used to control input/output options

        griddat.inc is used to define array sized, parameters etc that are relevant to primitive basis (grid).

psidef.inc : definition related to the representation of single particle function (spf) for wave function (zetf, zpsi, dim, vdim, ndim etc.)



* Utility functions that perform tensor manipulation, could use the same one in the MCTDH code.
  
  

* A main function that group rdpsiinfo.f90 (read information for wave function psi),
  
  read wave function itself (rdpsi.f90) and compute the size of blocks (psidat.f90) together than help read wave function psi.



After writing the psi read function, we should write a code similar to the one in 

analyze program in MCTDH to test whether we have any error. The simplist example I have in mind would be norm.F90 in analyse.



Remeber, the idea is not  to copy MCTDH code, but write a one that is clean and easy to understand and only handle one common scenario.














