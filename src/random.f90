!> A simple module for easy random number generation in Fortran90
!! All functionality can be accessed directly via the interface function call RANDOM(...).
!!
!! Functionality contained:
!!      - Pseudo-random real number on intervall [0,1): random()
!!      - Pseudo-random real number on intervall [a,b]: random(a,b)
!!      - List of N pseudo-random real number on intervall [0,1): random(N)
!!      - List of N pseudo-random real number on intervall [a,b]: random(a,b,N)
!!      - Pseudo-random integers on intervall [a,b]: random(a,b)
!!      - List of N pseudo-random integers on intervall [a,b]: random(a,b,N)
!!
!! Author: Lukas Lamm (lamm@ifam.rwth-aachen.de)
module fr_random
    implicit none
    private 
    
    ! Define parameters for module
    integer, parameter :: dp = selected_real_kind(15, 300)

    ! Overloading functions
    interface random
        module procedure random_real
        module procedure random_real_list
        module procedure random_real_interval
        module procedure random_real_interval_list
        module procedure random_int_interval
        module procedure random_int_interval_list
    end interface random

    interface bernoulli
        module procedure bernoulli_once
        module procedure bernoulli_list
    end interface bernoulli

    ! Set public visibility
    public :: dp
    public :: random
    public :: bernoulli

contains

    !> Computed the outcome of a bernoulli (coin flip) experiment
    !! Returns either 0 or 1 depending on the outcome of the coin flip
    function bernoulli_once() result(res)

        integer       :: res
        real(kind=dp) :: u

        ! Set random seed & generate random number on [0,1]
        u = random()

        ! Determine output from pseudo-random number
        res = 0
        if (u < 0.5d0) then
            res = 1
        end if

    end function bernoulli_once

    !> Computed  a list of N outcomes of a bernoulli (coin flip) experiment
    !! Returns either 0 or 1 depending on the outcome of the coin flip
    function bernoulli_list(num_results) result(res)

        integer, intent(in)             :: num_results
        integer, dimension(num_results) :: res
        integer                         :: i

        do i=1,num_results,1
            res(i) = bernoulli_once()
        end do 

    end function bernoulli_list
    
    !> Compute a real pseudo-random number using RANDOM_NUMBER intrinsic
    function random_real() result(number)

        real(kind=dp) :: number

        ! Set random seed & generate random number on [0,1]
        call random_init(.false., .false.)
        call random_number(number)

    end function random_real

    !> Compute a list of N pseudo-random real numbers using RANDOM_NUMBER intrinsics
    function random_real_list(num_numbers) result(numbers)

        integer,                              intent(in) :: num_numbers
        real(kind=dp), dimension(num_numbers)            :: numbers
        integer                                          :: i

        numbers = 0.d0
        do i = 1,num_numbers,1
            numbers(i) = random_real()
        end do

    end function random_real_list

    !> Compute a real pseudo-random number on the intervall [a,b] using RANDOM_NUMBER intrinsic
    function random_real_interval(a, b) result(number)

        real(kind=dp), intent(in) :: a
        real(kind=dp), intent(in) :: b
        real(kind=dp)             :: number

        ! Check for consistency of inputs
        if (b <= a) then
            write(*,'(A, F6.2, A, F6.2, A)') "RANDOM(a,b): Argument b = ",b ," must always be greater than argument a = ", a,"!" 
            error stop
        end if

        number = a + (b-a)*random_real()

    end function random_real_interval

    !> Compute a list of N pseudo-random real numbers on the intervall [a,b] using RANDOM_NUMBER intrinsics
    function random_real_interval_list(a,b,num_numbers) result(numbers)

        real(kind=dp),                        intent(in) :: a
        real(kind=dp),                        intent(in) :: b
        integer,                              intent(in) :: num_numbers
        real(kind=dp), dimension(num_numbers)            :: numbers
        integer                                          :: i

        numbers = 0.d0
        do i = 1,num_numbers,1
            numbers(i) = random_real_interval(a,b)
        end do

    end function random_real_interval_list

    !> Compute a pseudo-random integer on the interval [a,b]
    function random_int_interval(a,b) result(number)

        integer, intent(in) :: a
        integer, intent(in) :: b
        integer             :: number

        ! Check for consistency of inputs
        if (b <= a) then 
            write(*,'(A, I6, A, I6, A)') "RANDOM(a,b): Argument b = ",b ," must always be greater than argument a = ", a,"!" 
            error stop
        end if

        number = a + floor((b+1-a)*random_real())

    end function random_int_interval

    !> Compute a list of N pseudo-random integers on the intervall [a,b] using RANDOM_NUMBER intrinsics
    function random_int_interval_list(a,b,num_numbers) result(numbers)

        integer,                        intent(in) :: a
        integer,                        intent(in) :: b
        integer,                        intent(in) :: num_numbers
        integer, dimension(num_numbers)            :: numbers
        integer                                    :: i

        numbers = 0
        do i = 1,num_numbers,1
            numbers(i) = random_int_interval(a,b)
        end do

    end function random_int_interval_list
end module fr_random