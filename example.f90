!> Examples and testing of FortRAND
program example

    use fr_sampling, only: dp, normal_dist, shift_normal_distributed, exponential_dist
    use fr_random,   only: random

    implicit none

    integer, parameter          :: N = 10 
    real(kind=dp), parameter    :: a = -2
    real(kind=dp), parameter    :: b = 3
    real(kind=dp), parameter    :: mean = 2
    real(kind=dp), parameter    :: std = 1.5
    integer, parameter          :: c = -10
    integer, parameter          :: d = 100
    real(kind=dp)               :: random_number
    real(kind=dp), dimension(N) :: random_number_list
    integer                     :: random_integer
    integer                     :: i

    !---------------------------------------------------------!
    ! Testing random function
    !---------------------------------------------------------!
    ! Get pseudo-random real number on [0,1)
    random_number = random()
    write(*,'(A, F7.5)') "Pseudo-random real number on [0,1) with random(): ", random_number

    ! Get pseudo-random real number on [a,b]
    random_number = random(a,b)
    write(*,'(A,F7.4,A,F7.4,A,F7.5)') "Pseudo-random real number on [", a, ",", b, "] with random(a,b): ", random_number

    ! Get a list of N pseudo-random real numbers on [0,1)
    random_number_list = random(N)
    write(*,'(A)') "List of N pseudo-random real numbers on [0,1) with random(N):"
    do i=1,N,1
        write(*,'(5X, I2, A, F7.4)') i, ": ", random_number_list(i)
    end do

    ! Get a list of N pseudo-random real numbers on [a,b]
    random_number_list = random(a,b,N)
    write(*,'(A)') "List of N pseudo-random real numbers on [a,b] with random(a,b,N):"
    do i=1,N,1
        write(*,'(5X, I2, A, F7.4)') i, ": ", random_number_list(i)
    end do

    ! ! Get pseudo-random integer 0 or 1
    ! random_integer = random()
    ! write(*,'(A, I3)') "Pseudo-random integer on (0 or 1) with random(): ", random_integer

    ! Get pseudo-random integer on [c,d]
    random_integer = random(c,d)
    write(*,'(A, I3)') "Pseudo-random integer on [c,d] with random(c,d): ", random_integer

    !---------------------------------------------------------!
    ! Testing sampling algorithms
    !---------------------------------------------------------!
    ! Get a list of N pseudo-random real numbers from (standardized) normal distribution
    random_number_list = normal_dist(N)
    write(*,'(A)') "List of N pseudo-random real numbers from (stand.) normal distribution with normal_dist(N):"
    do i=1,N,1
        write(*,'(5X, I2, A, F7.4)') i, ": ", random_number_list(i)
    end do

    ! Get a list of N pseudo-random real numbers from (standardized) normal distribution using Box-Muller Algorithm
    ! Other algorithms are:
    !      MBA (default) - Marsaglia Bray Algorithm
    !      BMA           - Box Muller Algorithm
    !      CLT           - Central Limit Theorem
    random_number_list = normal_dist(N, "BMA")
    write(*,'(A)') "List of N pseudo-random real numbers from (stand.) normal distribution with normal_dist(N, 'BMA'):"
    do i=1,N,1
        write(*,'(5X, I2, A, F7.4)') i, ": ", random_number_list(i)
    end do

    ! Shift the results from standard normal distribution to fit with MEAN mean and STD standard-deviation
    random_number_list = shift_normal_distributed(random_number_list, mean, std)
    write(*,'(A)') "Shifted results using MEAN mean and STD standard-deviation:"
    do i=1,N,1
        write(*,'(5X, I2, A, F7.4)') i, ": ", random_number_list(i)
    end do

    ! Get a list of N pseudo-random real numbers from exponential distribution
    random_number_list = exponential_dist(N, 2.d0)
    write(*,'(A)') "List of N pseudo-random real numbers from exponential distribution with exponential_dist(N, lambda):"
    do i=1,N,1
        write(*,'(5X, I2, A, F7.4)') i, ": ", random_number_list(i)
    end do
    
end program example