Test: fortran-callcuda.f90 cudatest.o
	gfortran -L /usr/local/cuda-8.0/lib64 -I /usr/local/cuda-8.0/include -o Test fortran-callcuda.f90 cudatest.o -lcuda -lcudart
cudatest.o: cudatest.cu 
	nvcc -c -O3 cudatest.cu
clean:
	rm Test cudatest.o
