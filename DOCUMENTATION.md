# A Short Documentation of FortRAND

## Installation
Please see the [README.md](README.md) file for information on how to set up FortRAND with your own project.

## Random number generation
FortRAND provides you with a simple interface to the Fortran intrinsic pseudo-random number generator. To use the interface, you need to include the ```fr_random``` module to your source code:
```Fortran
use fr_random
```
Through function overloading, the ```random``` function provides you with various possibilities for generating pseudo-random numbers by using the same function call with various different parameters.

### Pseudo-random real numbers
You can generate a pseudo-random real number from the interval ```[0,1)``` easily by using
```Fortran
real(kind=8) :: rand_number 
rand_number = random()
```
If you want a pseudo-random real number within an interval ```[a,b]```, it is just as easy:
```Fortran
real(kind=8) :: rand_number 
real(kind=8) :: a
real(kind=8) :: b
a = -1.d0
b = 22.d0
rand_number = random(a, b)
```
Be aware that ```a < b``` must hold true, otherwise the ```random``` function will throw an error.

It is also really easy to generate an array of pseudo-random real numbers from the interval ```[0,1)```. All you need to do is 
```Fortran
integer                    :: N
real(kind=8), dimension(N) :: rand_number 
N = 10000
rand_number = random(N)
```
The same holds if you want to generate an array of pseudo-random real numbers within an interval ```[a,b]```:
```Fortran
integer                    :: N
real(kind=8), dimension(N) :: rand_number 
real(kind=8)               :: a
real(kind=8)               :: b
N = 10000
a = -1.d0
b = 22.d0
rand_number = random(a,b,N)
```

### Pseudo-random integers
For pseudo-random integers you can use the same ```random``` interface as before. The only difference is that creating a single pseudo-random integer does not make any sense without defining an interval to choose from at the same time. You can therefore only use the following two versions of ```random``` with integer return types.
```Fortran
integer               :: N
integer               :: rand_number
integer, dimension(N) :: rand_array
integer               :: a
integer               :: b
N = 10000
a = -1
b = 10
rand_number = random(a,b)
rand_array = random(a,b,N)
```

### Bernoulli experiment
If you want to simulate a Bernoulli (coin-flip) experiment, you can use the corresponding ```bernoulli``` function as
```Fortran
integer :: coin_flip
coin_flip = bernoulli()
```
Similar to the ```random``` function, you can also use ```bernoulli``` to generate a list of coin-flip results, e.g.
```Fortran
integer, parameter    :: N = 100
integer, dimension(N) :: coin_flips
coin_flips = bernoulli(N)
```

## Sampling from a Probability Distribution
FortRAND also gives you the possibility to draw samples from various probability distributions. Distributions supported are currently:
- Normal Distribution
- Exponential Distribution

To use the sampling possibilities, you would need to include the ```sampling``` module to your code via
```Fortran
use fr_sampling
```

### Normal Distribution
To draw samples from a standardized normal distribution (mean of zero and standard-deviation of one), you can use the ```normal_dist``` interface. By default this interface will use the Marsaglia-Bray/Polar Algorithm [see G. Marsaglia, T. Bray (1964)] for generating the samples. The corresponding function call would look like this:
```Fortran
integer, parameter         :: N = 1000
real(kind=8), dimension(N) :: rand_number_list
rand_number_list = normal_dist(N)
```
You can choose which algorithm you want to use by providing an additional flag to the function call. The overall list of methods provided by this is as follows:
| Algorithm | Default | Flag | Literature |
| --------- | :-----: | :--: | --------- |
| Marsaglia-Bray/Polar Algorithm | X | "MBA" | G. Marsaglia, T. Bray (1964) |
| Central Limit Theorem | | "CLT" | |
| Box-Muller Algorithm | | "BMA" | G. Box, M. Muller (1958) |

For example, if you would want to use Box-Muller instead of the default, just use the function call as
```Fortran
integer, parameter         :: N = 1000
real(kind=8), dimension(N) :: rand_number_list
rand_number_list = normal_dist(N, "BMA")
```
Now you are able to to sample numbers from the normal distribution with a mean of zero and a standard deviation of one. But how do you get samples for any other combination of mean and standard deviation. This is quiet simple in FortRAND, just use the ```shift_normal_distributed``` function from the ```sampling``` module, for example
```Fortran
integer, parameter         :: N = 1000
real(kind=8), parameter    :: mean = 2.0
real(kind=8), parameter    :: std = 1.5
real(kind=8), dimension(N) :: rand_number_list
rand_number_list = normal_dist(N)
rand_number_list = shift_normal_distributed(rand_number_list, mean, std)
```

### Exponential Distribution
Sampling from the exponential distribution is achieved by using the inversion method. You can use this method via the ```exponential_dist``` function, e.g.
```Fortran
integer, parameter         :: N = 1000
real(kind=8), parameter    :: lambda = 2.5d0
real(kind=8), dimension(N) :: rand_number_list
rand_number_list = exponential_dist(N, lambda)
```
Please use the following arguments within the function call:
| Argument | Optional | Restrictions | Description |
| -------- | :------: | ------------ | :---------- |
| N        | No       | N > 0        | Number of samples to be drawn |
| lambda   | No       | lambda > 0   | Rate parameter |

### Erlang distribution
Sampling from the erlang distribution is achieved by using the inversion method. You can use this method via the ```erlang_dist``` function, e.g.
```Fortran
integer, parameter         :: N = 1000
real(kind=8), parameter    :: lambda = 2.5d0
integer, parameter         :: k = 3
real(kind=8), dimension(N) :: rand_number_list
rand_number_list = erlang_dist(N, lambda, k)
```
Please use the following arguments within the function call:
| Argument | Optional | Restrictions | Description |
| -------- | :------: | ------------ | :---------- |
| N        | No       | N > 0        | Number of samples to be drawn |
| lambda   | No       | lambda > 0   | Rate parameter |
| k        | No       | k > 1        | Shape parameter |

