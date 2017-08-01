# cuda-kernel-wrapper-fortran
Sample for writing cuda kernel wrapper for FORTRAN
The codes in this repository are example for writing a CUDA kernel wrapper to be called from FORTRAN.
Generally, there is no noticeable performance difference between kernel wrapper function-call vs 
native code in C/C++. This technique is suitable if you need to modify a large legacy FORTRAN code by part,
offloading compute intensive step without major re-write of codes.
