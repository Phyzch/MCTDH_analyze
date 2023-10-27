!-----------------------------------------------------------------------
! Library subroutine zerovxi
!
! makes all the elements of an integer vector zero
!     vec(i)=0
!-----------------------------------------------------------------------
subroutine zerovxi(vec,dim)

    implicit none

    integer    dim,i
    integer    vec(dim)

    do i=1,dim
        vec(i)=0
    enddo

    return
end

! ----------------------------------------------------------------------
! Library subroutine cpvxz
!
! copies a complex vector to a different complex vector
!     w(i) = v(i)
!-----------------------------------------------------------------------

subroutine cpvxz (v,w,dim)
    integer dim,i
    complex*16  v(dim),w(dim)

    do i = 1,dim
        w(i) = v(i)
    enddo

    return
end