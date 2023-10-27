!-----------------------------------------------------------------------
! Library subroutine vvaxzz
!
! scalar product of two complex vectors:
!     dconjg(u(i))*v(i)=s
!-----------------------------------------------------------------------
subroutine vvaxzz (u,v,s,dim)

    implicit none

    integer     dim,i
    complex*16  u(dim),v(dim),s

    s = dconjg(u(1))*v(1)
    do i = 2,dim
        s = s+dconjg(u(i))*v(i)
    enddo

    return
end