pushd %~dp0
cd build
cmake .. -G"Visual Studio 14 Win64"
popd