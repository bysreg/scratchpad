pushd %1
cd build
cmake .. -G"Visual Studio 14 Win64"
popd