@REM @echo off
g++.exe   -c problem3.cpp -o problem3.o
g++.exe  -o problem3.exe ./problem3.o  -static
problem3.exe<problem3_input>problem3_program_output
comp problem3_output problem3_program_output /D /A /L /M