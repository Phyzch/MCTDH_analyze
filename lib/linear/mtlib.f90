!-----------------------------------------------------------------------
! Library subroutine qtxxzz
!
! Multiplication of a complex quadratic matrix with a complex tensor
! of third order:
!           a(l,j)*b(i,j,k) = c(i,l,k).
! A * B[i] = C[i]
! Input-variables:  a      - complex matrix
!                   b      - complex tensor of third order
! Output-variables: c      - resulting complex tensor
!-----------------------------------------------------------------------

subroutine qtxxzz (a,b,c,dim1,dim2,dim3)

    implicit none

    integer       dim1,dim2,dim3, i, j, k, l
    complex*16    a(dim2,dim2),b(dim1,dim2,dim3),c(dim1,dim2,dim3)

    if (dim1.ne.1 .and. dim3.ne.1) then
        do k=1,dim3
            do l=1,dim2
                do i=1,dim1
                    c(i,l,k)=a(l,1)*b(i,1,k)
                enddo
            enddo
        enddo
        do k=1,dim3
            do j=2,dim2
                do l=1,dim2
                    do i=1,dim1
                        c(i,l,k)=c(i,l,k)+a(l,j)*b(i,j,k)
                    enddo
                enddo
            enddo
        enddo
    else if (dim1.eq.1 .and. dim3.ne.1) then
        do k=1,dim3
            do l=1,dim2
                c(1,l,k)=a(l,1)*b(1,1,k)
            enddo
        enddo
        do k=1,dim3
            do j=2,dim2
                do l=1,dim2
                    c(1,l,k)=c(1,l,k)+a(l,j)*b(1,j,k)
                enddo
            enddo
        enddo
    else if (dim1.ne.1 .and. dim3.eq.1) then
        do l=1,dim2
            do i=1,dim1
                c(i,l,1)=a(l,1)*b(i,1,1)
            enddo
        enddo
        do j=2,dim2
            do l=1,dim2
                do i=1,dim1
                    c(i,l,1)=c(i,l,1)+a(l,j)*b(i,j,1)
                enddo
            enddo
        enddo
    else if (dim1.eq.1 .and. dim3.eq.1) then
        do l=1,dim2
            c(1,l,1)=a(l,1)*b(1,1,1)
        enddo
        do j=2,dim2
            do l=1,dim2
                c(1,l,1)=c(1,l,1)+a(l,j)*b(1,j,1)
            enddo
        enddo
    endif

    return
end
