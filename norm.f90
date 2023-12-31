! Created by phyzch on 10/27/23.
! This file is based on norm.F90 file in /source/analyse/
! Use this code to test whether we have handled the psi file correctly.
subroutine norm()
    use psidef
    use daten
    use griddat

    integer i,j,k,s,m
    integer t_index
    integer ilog      ! file unit for record norm
    integer norm_out_id

    complex *16 ovl, aovl
    real wavefunc_norm, wavefunc_normsq, anormsq, anorm
    real time


    Character( len = :), allocatable :: norm_log_filename, norm_filename
    Character (len = :), allocatable :: norm_log_filepath, norm_filepath

    ! file unit for record norm
    ilog = 1
    ! file unit for output norm
    norm_out_id = 2
    ! unit # for ipsi.
    ipsi = 3

    norm_log_filename = "norm.log"
    norm_filename = "norm"

    norm_log_filepath = output_folderpath // norm_log_filename
    norm_filepath = output_folderpath// norm_filename

    open(unit = ilog, file = norm_log_filepath, action = "WRITE" ,form = "formatted")
    ! formatted means the file will be treated as a text file with human readable content.

    open(unit = norm_out_id, file = norm_filepath, action = "WRITE", form = "formatted")


    ! read the wave function.
    ! results stored in psi_array(dgldim, psi_number), time_list(psi_number)
    call read_psi()

    allocate(psi_t(dgldim))

    do t_index = 1, psi_number
        ! t_index is index for time
        ! psi_t: wave function at time t
        psi_t = psi_array(:, t_index)

        time = time_list(t_index)

        ! ovl: square of wave function norm.
        ! aovl: square of A tensor vector norm.
        call norm_each_t( ovl, aovl)

        ! output result
        wavefunc_normsq = dble(ovl)
        wavefunc_norm = sqrt(wavefunc_normsq)
        anormsq = dble(aovl)
        anorm = sqrt(anormsq)

        write(norm_out_id, '(f12.4,1x,2f13.9,2x,2f13.9)') &
                time, wavefunc_normsq, anormsq, wavefunc_norm, anorm
    end do

    close(ilog)
    close(norm_out_id)
    deallocate(psi_t)

end subroutine norm

! compute the norm of wave function for each time t.
subroutine norm_each_t(ovl, aovl)
    use psidef
    use daten
    use griddat

    integer i,j,k,s,m, zeig1, zeig2, swapzeig
    complex *16 ovr(dmatdim),  zdum

    ! ovl: norm of the wave function.
    ! avol: norm of tensor coefficient A.
    complex *16, intent(inout):: ovl, aovl

    complex *16 , pointer :: workc(:)


    workcdim = 2 * maxblock
    allocate(workc(workcdim))

    !-----------------------------------------------------------------------
    !     calculate density matrices for each degree of freedom defined as
    !     overlap of the single-particle functions rho^m_ij=<phi_i,2|phi_j,1> Here m indicates the mode index.
    ! here |phi_i^m> and |phi_j^m> are all single particle functions in mode m.
    !-----------------------------------------------------------------------
    do s = 1, nstate
        do m = 1, nmode
            ! defined in lib/mmlib.f90
            call mmaxzz(psi_t(zetf(m,s)) , psi_t(zetf(m,s)), ovr(dmat(m,s)) , &
                    subdim(m), dim(m,s), dim(m,s))
            ! see rdpsidef.f90 for dmat(m,s). This is the index for density matrix.
        end do
    end do

    !----------------------------------------------------------------------
    ! calculate Sum_L <Phi_J|Phi_L> A_L within each state
    !----------------------------------------------------------------------
    ovl=(0d0,0d0)
    do s=1,nstate
        zeig1=1
        zeig2=block(s)+1
        ! defined in lib/op1lib.f90 : copy complex vector.
        call cpvxz(psi_t(zpsi(s)),workc(zeig2),block(s))

        do m=1,nmode
            swapzeig=zeig1
            zeig1=zeig2
            zeig2=swapzeig
            ! see /lib/mtlib.f90.
            call qtxxzz(ovr(dmat(m,s)),workc(zeig1),workc(zeig2),&
                    vdim(m,s),dim(m,s),ndim(m,s))
            ! both workc(zeig1), workc(zeig2) have space block(s)
            ! It's actually matrix * vector = vector if we look at mode m.
            ! ovr : rho (density matrix). workc(zeig1) : tensor A. workc(zeig2) : store rho * A.
            ! by exchange zeig1, we can consecutively do rho * A for all dof m.
        enddo

        !-------------------------------------------------------
        !     now workc(zeig2) store the Sum_L <Phi_J|Phi_L>A_L
        !-----------------------------------------------------

        !-----------------------------------------------------------------------
        ! calculate Sum_J A_J^* Sum_L <Phi_J|Phi_L>A_L within each state
        ! workc(zeig2) = sum_L <phi_J|phi_L> A_L
        ! This is just scalar product of two vectors. result is stored in zdum.
        !-----------------------------------------------------------------------
        ! see lib/xvlib.f90
        call vvaxzz(psi_t(zpsi(s)),workc(zeig2),zdum,block(s))

        ovl=ovl+zdum
    enddo

    !-----------------------------------------------------------------------
    ! calculate Sum_J A_J^*  * A_J
    ! result stored in aovl.
    !-----------------------------------------------------------------------
    ! see lib/xvlib.f90
    call vvaxzz(psi_t,psi_t,aovl,adim)

    deallocate(workc)

    return
end subroutine norm_each_t