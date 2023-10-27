! Created by phyzch on 10/23/23.
! contain definition of variables about representing wave function using single particle functions (spf).
! Also contain information about coefficient tensor A.
module psidef
    implicit none
    !-----------------------------------------------------------------------
    ! VARIOUS INTEGERS DEFINING SIZE OF WAVEFUNCTION
    !
    ! dgldim   : Length of array containing wavefunction
    !            dgldim = block + Sum[dim(m)*subdim(m)]
    ! dmatdim  : Length of array containing the density matrices
    !            dmatdim = Sum[dim(m)*dim(m)]
    ! adim     : Cumulative length of all A vectors.
    !            adim = Sum[block(s)]
    ! maxspf   : Largest number of single-particle functions
    !            maxspf = Max_(m,s) dim(m,s)
    !-----------------------------------------------------------------------
    integer dgldim, dmatdim, adim, maxspf

    !-----------------------------------------------------------------------
    ! ARRAY DIMENSIONS DEPENDENT ON NMODE
    !
    ! PhiDim(M): Length of phi-vector for mode m
    !            PhiDim(M) = Sum[Dim(S,M)*SubDim(M)]
    ! maxphidim: Size of largest phi vector
    !            maxphidim = max[phidim(m)]
    ! totphidim: overall size of single-particle functions
    !            totphidim = Sum_m [phidim(m)] = dgldim-adim
    !-----------------------------------------------------------------------
    integer maxphidim, totphidim
    integer, pointer :: phidim(:)

    !-----------------------------------------------------------------------
    ! INFORMATION ABOUT WAVEFUNCTION TYPE
    !
    ! psitype: 0 = MCTDH (default)
    !          1 = numerically exact (full grid representation)
    !          3 = multilayer
    !         10 = MCTDH (dynamical WF)
    !         11 = ML-MCTDH (dynamical WF)
    !-----------------------------------------------------------------------
    integer psitype

    !--------------------------------------------------
    ! POINTERS FOR ARRAYS
    !
    ! dim(m,s)   : number of single particle functions for mode m
    ! vdim(m,s)  : cumulative number of preceeding degrees of freedom
    ! ndim(m,s)  : cumulative number of following degrees of freedom

    ! zpsi(s)    : pointer to wavefunction for state s
    ! block(s)   : number of MCTDH A coefficients for state s

    ! zetf(m,s)  : pointer to start of single particle functions for mode
    !              m in psi
    ! dmat(m,s)  : pointer to start of dichte matrices for mode m

    ! the size of the array (matrix) is not set here, will need to allocate the memory using allocate statement.
    !--------------------------------------------------
    integer,pointer :: dim(:,:),vdim(:,:),ndim(:,:)
    integer,pointer :: zpsi(:),block(:)
    integer,pointer :: dmat(:,:)
    integer,pointer :: zetf(:,:)

    !--------------------------------------
    ! Below are the variables I am quite sure what's it's for,  but it's stored in psidef part.
    ! msymmtr    : Array specifying (a)symmetrization of DOFs and 2D SPFs
    ! idmode     : Array specifying identical (by symmetry) modes
    ! symcv      : Array specifying partial symmetrization of A-vector
    ! citype
    !-------------------------------------
    integer, pointer :: msymmtr(:), idmode(:), symcv(:)
    integer citype

    !--------------------------------------------------------
    ! 2d array stores wave function at different time step
    ! we will store the wave function psi in there in read_psi_wavefunction.f90
    !-------------------------------------------------------
    integer psi_number  ! number of time steps for wave function arrays recorded
    complex(kind=selected_real_kind(33, 4931)), pointer :: psi_array(:,:) ! 2d array of wave function for all time step
    real , pointer :: time_list(:)  ! record time for the wave function.

end module psidef