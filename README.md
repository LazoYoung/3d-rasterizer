## Contribute
### Install GLFW
1. Download [GLFW pre-compiled binaries](https://www.glfw.org/download.html) for Windows 64-bit
2. Unzip the file to extract `include` and `lib-vc2022` folders
3. Rename `lib-vc2022` to `lib`
4. Place the folders under the project root

### Install GLAD
1. Download [glad.zip](https://glad.dav1d.de/#language=c&specification=gl&api=gl%3D3.3&api=gles1%3Dnone&api=gles2%3Dnone&api=glsc2%3Dnone&profile=core&loader=on) from GLAD load generator.
2. Unzip the file to extract `include` and `src` folders
3. Place them under the project root

### Build project
1. Run CMake to build the project
2. The executable file will be generated under `deploy` folder
