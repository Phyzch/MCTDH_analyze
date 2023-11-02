! Created by phyzch on 10/23/23.
! contain definitions of variables relevant to primitive basis (grid).
module griddat

    !------------------------------
    ! length of the string.
    integer , parameter :: c1 = 16 !PRCS:16
    integer , parameter :: c2 = 32 !PRCS:32
    integer , parameter :: c3 = 64 !PRCS:64
    integer , parameter ::c4 = 80 !PRCS:80
    integer , parameter ::c5 = 240 !PRCS:240
    !-----------------------------------------------------------------------
    ! VARIOUS INTEGERS DEFINING SYSTEM
    !
    ! ndof     : total number of degrees of freedom
    ! feb      : index of degree of freedom described by an electronic basis
    ! fpb      : index of degree of freedom described by a packet basis (useless)
    ! gdim(f)  : number of grid points for dof f
    ! maxgdim  : Max[gdim(f)]
    ! maxgdim2 : Max[gdim(f)**2]
    !-----------------------------------------------------------------------
    integer ndof, feb, fpb, maxgdim, maxgdim2
    integer, pointer :: gdim(:)

    !-----------------------------------------------------------------------
    ! HOW ELECTRONIC BASIS IS HANDLED
    !
    !  leb       : set to true if operator contains an electronic basis
    !  lmult     : multiple state calculation
    !  lmulpack  : two or more wavepackets are propagated simultaneously
    !-----------------------------------------------------------------------
    logical leb,lmult,lmulpack

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
    integer :: mbaspar

    !-----------------------------------------------------------------------
    ! PARAMETERS DEFINING PRIMITIVE BASIS
    !
    ! basis(f) : basis type for dof f
    ! rpbaspar(n,f): real parameters needed to define primitive basis
    ! ipbaspar(n,f): integer parameters needed to define primitive basis
    !-----------------------------------------------------------------------
    integer,pointer :: ipbaspar(:,:)
    real*8 ,pointer :: rpbaspar(:,:)
    real, pointer :: xend(:,:)

    ! basis(f) : basis type for dof f. (dof=degree of freedom)
    !     (0,1,2,3,4,5,6,7,8,9)->(el,HO,Leg,sin,FFT,exp,sphfbr,kleg,k,pleg)
    !     (-1,11,12,13) -> blank basis (phifbr), rHO, Leg/r, external-DVR
    !     (14,15,16,17,18) -> cos, Lagu1, Lagu2, Lagu3, Lagu4
    !     (19) -> wigner
    ! See einpbas.F in MCTDH program.
    integer,pointer :: basis(:)

    logical,pointer :: ldvr(:)
    character * (c1), pointer :: modelabel(:)

    !---------------------------------------------------------------------
    ! Parameters defining "combined" grids
    !
    ! lconm  (logical)  : calculation contains combined spf_s
    ! nmode    : number of spf degrees of freedom  (Also see ndof defined above)

    ! meb      : mode of the electronic basis (feb)
    ! mpb      : mode of the packet basis (fpb)  (useless, but we have to read from psi file)

    ! vgdim(f) : number of grid points for dofs preceeding f
    ! ngdim(f) : number of grid points for dofs following f
    ! subdim(m) : number of grid points for mode m

    ! npacket  : number of wavepackets to be propagated simultaneously (multi-set)
    ! npackts  : number of wavepackets to be propagated simultaneously (single-set)
    ! nstate: number of electronic states in calculation
    ! maxsubdim : Max[subdim(m)]



    ! nspfdof[nmode] : # of grid dof in each mode (single particle functions)
    ! spfdof[n,m]: index for grid dof in each combined mode. (n = 1 , nspfdof(m)), (m = 1, nmode)
    ! dofspf (f) : index of mode (spf) for grid dof f.
    ! See function griddef for more info.
    !--------------------------------------------------------------------
    logical lconm
    integer nmode,meb,mpb, nstate, maxsubdim, npacket, npackts
    integer, pointer :: subdim(:), vgdim(:), ngdim(:)

    integer,pointer :: nspfdof(:),spfdof(:,:),dofspf(:)

end module griddat