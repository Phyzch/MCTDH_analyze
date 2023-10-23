! Created by phyzch on 10/23/23.
! contain definitions of variables relevant to primitive basis (grid).
module griddat
    !-----------------------------------------------------------------------
    ! VARIOUS INTEGERS DEFINING SYSTEM
    !
    ! ndof     : total number of degrees of freedom
    ! feb      : number of degree of freedom described by an electronic basis
    ! gdim(f)  : number of grid points for dof f
    ! maxgdim  : Max[gdim(f)]
    ! maxgdim2 : Max[gdim(f)**2]
    !-----------------------------------------------------------------------
    integer ndof, feb, maxgdim
    integer, pointer :: gdim(:,:)

    !------------------------------------------------------------------------
    ! How electronic basis is handled
    ! leb : set to true if operator contains an electronic basis
    !------------------------------------------------------------------------
    logical leb

    !-----------------------------------------------------------------------
    ! VARIOUS INTEGERS DEFINING SIZE OF DVR
    !
    ! ortdim   : Length of array containing grid positions
    !            ortdim = Sum[subdim(m)]
    ! dvrdim   : Length of array containing DVR representations
    !            dvrdim = Sum[subdim(m)*subdim(m)]
    !            where sum is over modes using DVR
    !------------------------------------------------------------------------
    integer ortdim, dvrdim

    !-----------------------------------------------------------------------
    ! POINTERS FOR ARRAYS
    !
    ! zort(f)    : pointer for ort matrix for dof f
    ! zdvr(f)    : pointer for dvr matrices (dif1mat, dif2mat, trafo) for dof f
    !-------------------------------------------------------------------------
    integer,pointer :: zort(:),zdvr(:)

    !-----------------------------------------------------------------------
    ! PARAMETERS FOR ARRAY DIMENSIONS
    !
    !  mbaspar:    maximum number of parameters used to define bases
    !-----------------------------------------------------------------------
    integer, parameter :: mbaspar = 9

    !-----------------------------------------------------------------------
    ! PARAMETERS DEFINING PRIMITIVE BASIS
    !
    ! basis(f) : basis type for dof f
    ! rpbaspar(n,f): real parameters needed to define primitive basis
    ! ipbaspar(n,f): integer parameters needed to define primitive basis
    !-----------------------------------------------------------------------
    integer,pointer :: ipbaspar(:,:)
    real ,pointer :: rpbaspar(:,:)
    integer,pointer :: basis(:)
    character*(c1), pointer :: modelabel(:)

    !---------------------------------------------------------------------
    ! Parameters defining "combined" grids
    !
    ! lconm  (logical)  : calculation contains combined spf_s
    ! nmode    : number of spf degrees of freedom  (Also see ndof defined above)
    ! meb      : mode of the electronic basis (feb)
    ! nstate: number of separate electronic states in calculation

    ! vgdim(f) : number of grid points for dofs preceeding f
    ! ngdim(f) : number of grid points for dofs following f
    ! subdim(m) : number of grid points for mode m
    ! sdim : Max[subdim(m)]

    ! nspfdof[nmode] : # of grid dof in each mode (single particle functions)
    ! spfdof[n,m]: index for grid dof in each combined mode. (n = 1 , nspfdof(m)), (m = 1, nmode)
    ! dofspf (f) : index of mode (spf) for grid dof f.
    ! See function griddef for more info.
    !--------------------------------------------------------------------
    logical lconm
    integer nmode,meb,nstate, sdim
    integer, pointer :: subdim(:), vgdim(:), ngdim(:)

    integer,pointer :: nspfdof(:),spfdof(:,:),dofspf(:)

end module griddat