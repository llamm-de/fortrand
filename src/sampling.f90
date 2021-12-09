!> A simple module for random sampling of numbers
!!
!! Methods contained:
!!      - A general interface function for sampling from the normal distribution
!!          - Central Limit Theorem normal distribution sampling
!!          - Box Muller normal distribution sampling (Single pair & Set of values)
!!          - Marsaglia-Bray normal distribution sampling (Single pair & Set of values)
!!      - Shiftig of normal distribution values using mean and standard deviation
!!
!! Author: Lukas Lamm (lamm@ifam.rwth-aachen.de)
module fr_sampling

    use fr_random, only: random, bernoulli

    implicit none
    private

    ! Define parameters for module
    integer, parameter :: dp = selected_real_kind(15, 300)
    real(kind=dp), parameter :: PI = 4.0d0*DATAN(1.0d0)

    ! Set public visibility
    public :: dp
    public :: normal_dist
    public :: shift_normal_distributed
    public :: exponential_dist
    
contains

    !> Interface function to compute an array of NUM_SAMPLES samples from normal distribution
    !!
    !! The optional input argument METHOD (character of length 3) defines the method
    !! being used by the sampling procedure. The following methods are provided:
    !!      MBA (default) - Marsaglia Bray Algorithm
    !!      BMA           - Box Muller Algorithm
    !!      CLT           - Central Limit Theorem
    function normal_dist(num_samples, method) result(samples)

        integer, intent(in)                      :: num_samples
        real(kind=dp), dimension(num_samples)    :: samples
        real(kind=dp), dimension(num_samples,2)  :: tmp
        character(len=3), intent(in), optional   :: method 
        character(len=3)                         :: m

        ! Set default behaviour, if method is not provided
        if(present(method)) then
            m = method
        else 
            m = "BMA"
        end if

        ! Choose algorithm and compute values with it
        select case (m)
            case("BMA")
                tmp = box_muller(num_samples)
                samples = tmp(:,1)

            case("MBA")
                tmp = marsaglia_bray(num_samples)
                samples = tmp(:,1)

            case("CLT")
                samples = central_limit_theorem(num_samples)

            case default
                write(*,'(A, A, A)') "SAMPLE_NORMAL_DIST(N,METHOD): Argument METHOD = ", m, " is not known!"
                error stop

        end select

    end function normal_dist

    !> Compute an array of NUM_SAMPLES samples from normal distribution 
    !! using Central Limit theorem
    function central_limit_theorem(num_samples) result(samples)
        
        integer,                              intent(in) :: num_samples
        real(kind=dp), dimension(num_samples)            :: samples
        integer                                          :: i
        integer                                          :: j
        real(kind=dp)                                    :: sum

        do i = 1,num_samples,1
            sum = 0.0d0
            do j = 1,num_samples,1
                sum = sum + bernoulli()
            end do
            samples(i) = 2.d0 * sqrt(real(num_samples)) * (sum/num_samples - 0.5)
        end do

    end function central_limit_theorem

    !> Compute a single pair of random numbers from normal distribution
    !! using Marsaglia-Bray Algorithm [G. Marsaglia, T. Bray (1964)]
    function marsaglia_bray_pair() result(sample)

        real(kind=dp), dimension(2) :: u
        real(kind=dp)               :: q
        real(kind=dp)               :: p
        real(kind=dp), dimension(2) :: sample

        q = 0.0d0

        do while ((q == 0.0d0) .or. (q >= 1.0d0))
            u = random(-1.0d0, 1.0d0, 2)
            q = u(1)**2 + u(2)**2
        end do

        p = sqrt(-2.d0 * log(q)/q)
        sample(1)= u(1)*p
        sample(2)= u(2)*p

    end function marsaglia_bray_pair

    !> Compute an array of NUM_SAMPLES samples from normal distribution 
    !! using Marsaglia-Bray Algorithm [G. Marsaglia, T. Bray (1964)]
    function marsaglia_bray(num_samples) result(samples)

        integer,                                  intent(in) :: num_samples
        real(kind=dp), dimension(num_samples,2)              :: samples
        integer                                              :: i

        do i = 1,num_samples,1
            samples(i,:) = marsaglia_bray_pair()
        end do

    end function marsaglia_bray

    !> Compute a single pair of random numbers from normal distribution
    !! using Box-Muller Algorithm [G. Box, M. Muller (1958)]
    function box_muller_pair() result(sample)

        real(kind=dp), dimension(2) :: sample
        real(kind=dp), dimension(2) :: u

        ! Get random numbers
        u = random(2)
        
        ! Calculate normal distributed values using box muller algorithm
        sample(1) = sqrt(-2 * log(u(1))) * cos(2 * PI * u(2))
        sample(2) = sqrt(-2 * log(u(1))) * sin(2 * PI * u(2))

    end function box_muller_pair

    !> Compute an array of NUM_SAMPLES samples from normal distribution 
    !! using Box-Muller Algorithm [G. Box, M. Muller (1958)]
    function box_muller(num_samples) result(samples)

        integer,                                  intent(in) :: num_samples
        real(kind=dp), dimension(num_samples,2)              :: samples
        integer                                              :: i

        do i = 1,num_samples,1
            samples(i,:) = box_muller_pair()
        end do

    end function box_muller

    !> Compute shifted normal distribution from mean MEAN and standard deviation STD
    function shift_normal_distributed(values, mean, std) result(shifted_values)

        real(kind=dp), dimension(:),            intent(in) :: values
        real(kind=dp), dimension(size(values))             :: shifted_values
        real(kind=dp),                          intent(in) :: mean
        real(kind=dp),                          intent(in) :: std
        integer                                            :: i

        do i = 1,size(values),1 
            shifted_values(i) = mean + std*values(i)
        end do

    end function shift_normal_distributed

    !> Interface function to compute an array of NUM_SAMPLES samples 
    !! from exponential distribution using the inversion method
    function exponential_dist(num_samples, lambda) result(samples)

        integer, intent(in)                   :: num_samples
        real(kind=dp), intent(in)             :: lambda
        real(kind=dp), dimension(num_samples) :: samples
        real(kind=8)                          :: u
        integer                               :: i

        ! Check for input consistency
        if (lambda <= 0) then 
            write(*,'(A, F6.2, A)') "EXPONENTIAL_DIST(n,lambda): Argument lambda = ", lambda ," must always be greater than 0!" 
            error stop
        end if

        samples = 0.d0
        do i=1,num_samples,1
            u = random()
            samples(i) = -1/lambda*log(u)
        end do

    end function exponential_dist

end module fr_sampling
