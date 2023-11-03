!-----------------------------------------------------------------------
! Library subroutine mmaxzz
!
! Multiplication of the adjoint of a complex rectangular matrix with
! a rectangular complex matrix
!     dconjg(a(k,j))*b(k,i) = c(j,i)
!
! NB this routine can be used for the overlap of two sets of vectors in
!   different spf bases
!----------------------------------------------------------------------


subroutine mmaxzz (a,b,c,dim1,dim2,dim3)

    implicit none

    integer     dim1,dim2,dim3,i,j,k
    complex*16  a(dim1,dim2),b(dim1,dim3),c(dim2,dim3)

    do i = 1,dim3
        do j = 1,dim2
            c(j,i) = dconjg(a(1,j))*b(1,i)
            do k = 2,dim1
                c(j,i) = c(j,i)+dconjg(a(k,j))*b(k,i)
            enddo
        enddo
    enddo

    return
end