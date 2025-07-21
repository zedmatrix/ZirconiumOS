#!/bin/bash
File="main.cpp"
outfile="zget"
options="-lcurl -lcrypto"

printf "\n\t Compiling ... $File \n"

# compile with std C++23
g++ -std=c++23 $File $options -o $outfile

if [ $? -eq 0 ]; then
    printf "\t Compilation successful! Output: $outfile \n"
else
    printf "\t Compilation failed! \n"
fi
