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