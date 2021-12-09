# FortRAND - A lightweight random sampling library for modern Fortran

FortRAND is a lightweight random sampling library written in modern Fortran. 
It provides a simple interface to the build in Fortran pseudo-random number generator 
for the generation of uniformly distributed random numbers. In addition, it also provides 
algorithms for sampling numbers from various other distributions.

## Getting started
### Getting the software
You can get the most recent version of the package by cloning this repository using ```git```.

### Including it into your project
Since FortRAND does not depend on third party software, you can easily include the library into your project. There are various ways of doing it. The most common ones are explained in the following.

#### Using CMake
If you are already using [CMake](https://www.cmake.org) you are lucky. Since FortRAND is build around CMake, you can easily integrate FortRAND into your project. To do so, you should first add this repository as a git submodule to your project:
```bash
git submodule add https://github.com/llamm-de/fortrand.git
git submodule init
git submodule update
```
Next, add the past to FortRAND's source folder as a subdirectory within your own ```CMakeLists.txt```:
```
add_subdirectory(<PATH_TO_SOURCE_FOLDER>)
```
Last but not least, you can directly link against the library:
```
target_link_libraries(<YOUR_EXECUTABLE_NAME> fortrand)
```
Et Voila! This should be sufficient to add FortRAND to your project.

#### Copying it directly to your sources
Since FortRAND is relatively small, you can also just copy the source files to your project and include them as if you wrote them yourself. But be aware that this makes it much harder to update the version of FortRAND you are using. We would therefore strongly recommend to use CMake and git submodules instead.

## Documentation & Examples
You can find a simple documentation within the [DOCUMENTATION.md](DOCUMENTATION.md) file. The source code is also extensively documented. If you want to test some example code, please use the provided [CMakeLists.txt](CMakeLists.txt) file to build and run the examples.


## Contributing
If you want to participate in the development of this piece of software feel free to clone the project and open a pull request when necessary. If you want to report any bugs or want to suggest improvements, please open an issue.

## Licensing
This software is published under the LGPL V3. For details please see the [LICENSE](LICENSE.md) file.