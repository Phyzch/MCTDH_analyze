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

end module psidef