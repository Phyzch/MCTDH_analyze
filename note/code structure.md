# Write code to analyze MCTDH code psi file output

## File structure

- include 
  
  - daten.f90:contains information about input / output control options & time variables (tinit, out2, tfinal). This is adapted from /include/daten.inc file in the source code of MCTDH program
  
  - griddat.f90: contains definitions of variables relevant to primitive basis (DVR grid) and also how we group DVR grids to form single particle function (SPF) mode. The code is adapted from /include/griddat.inc from MCTDH source code.
  
  - psidef.f90: contains definitions of variables about representing wave function using single particle functions (spf) and coefficient tensor A. This code is adapted from /include/psidef.inc from MCTDH source code.

- lib: Linear algebra library for tensor manipulation. (We would use them in norm.f90) This is copied from MCTDH source code library. 
  
  - linear/mmlib.f90
  
  - linear/mtlib.f90
  
  - linear/op1lib.f90
  
  - linear/xvlib.f90

- read_psi: code for reading and deciphering psi file in the MCTDH package.
  
  - read_psi_wavefunc.f90: main function for deciphering psi file. For the structure of the psi file, see Output.html in MCTDH document. For the structure and layout of psi 1d array, see Appendix D: Structure of the WF array in guide.pdf of MCTDH. The code will call rdpsiinfo(ipsi) in rdpsiinfo.f90 to read Header info:  dvrdef, grddef, psidef, nopt, lpsiopt, tinit, out2. Then it will call rdpsi(ipsi, lend) in rdpsi.f90 to read 1d wave function array psi. The wave function result will store in psi_array (dgldim, psi_number), the time for wave function will store in time_list(psi_number). (Here psi_number is number of wave function , corresponds to number of time step in simulation).

- read_psiinfo: folder contains code to read Header info of the MCTDH psi file. The main function in this folder is rdpsiinfo.f90. The rdpsiinfo.f90 will call functions rddvrdef.f90, rdgrddef.f90, rdpsidef.f90 to read dvr info, grid info and wave function (psi) info.  The structure of wave function has 3 layers, the first layer is primitive basis with DVR representation (grid), in total ndof # (See section 4: selecting a DVR/FBR representation for the primitive basis in guide.pdf). The second layer is single particle function (SPF) by combining primitive basis (grid) into single particle function mode (in total nmode #). (See section 5: Defining the single-particle basis in guide.pdf). The third layer is wave function itself, which we represent wave function with tensor coefficient A and single particle functions (SPFs) defined on single-particle basis (mode) (The number of single particle functions used for defining wave function is dim(m,s)).  

    - rdpsiinfo.f90: This code is adapted from rdpsiinfo subroutine in /source/mctdh/iofile.F in MCTDH source code. It will call subroutine rddvrdef(unit) (read dvr definition), rdgrddef(unit) (read grid definition) and rdpsidef(unit) (read wave function psi definition).
    
    
    
    - rddvrdef.f90: This code will read dvr definition, which is the information for discrete variable representation (DVR) along each grid dof (first layer of wave function structure). This code is adapted from rddvrdef subroutine from /source/mctdh/iodvrdef.F code in MCTDH source code. See output docu.html for information about dvrdef information set. DVR information is about how we define the grid points (in total ndof # of grid dofs, each is defined with discrete variable representation (DVR))
    
    
    
    - rdgrddef.f90: This code will read grid definition, which is how we combine primitive basis into single particle basis (second layer of wave function structure). This code is adapted from rdgrddef subroutine in /source/mctdh/iogrddef.F in MCTDH source code. See output doc.html for information about grddef information set. 
    
    
    
    - rdpsidef.f90: This code will read wave function (psi) definition, which is how we construct wave function on single particle basis using tensor coefficient A and single particle functions (spf). This code is adapted from rdpsidef subroutine from /source/mctdh/iopsidef.F in MCTDH source code. See output doc.html for information about psidef information set.
    
    
    
    - rdpsi.f90: This code is adapted from rdpsi subroutine from /analyse/rdfiles.F. This will read the wave function and store it in psi(:) 1d array. 

- main.f90: main function for the fortran code

- norm.f90: norm function, adapted from /analyse/norm.F in fortran code. It will compute the norm of wave function and norm of tensor A vector.
  
- CMakeLists.txt: cmake file for fortran project.
