#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda.h>
#include <cuda_runtime.h>

//for cublas function
#include<cublas_v2.h>

// simple kernel function that adds two vectors
__global__ void vect_add(float *a, float *b, int N)
{
   int idx = threadIdx.x;
   if (idx<N) a[idx] = a[idx] + b[idx];
}

// function called from main fortran program
extern "C" void kernel_wrapper_(float *a, float *b, int *Np)
{
   float  *a_d, *b_d;  // declare GPU vector copies
   
   int blocks = 64;     // uses 1 block of
   int N = *Np;        // N threads on GPU

N = N/blocks;

   // Allocate memory on GPU
   cudaMalloc( (void **)&a_d, sizeof(float) * N );
   cudaMalloc( (void **)&b_d, sizeof(float) * N );

   // copy vectors from CPU to GPU
   cudaMemcpy( a_d, a, sizeof(float) * N, cudaMemcpyHostToDevice );
   cudaMemcpy( b_d, b, sizeof(float) * N, cudaMemcpyHostToDevice );

   // call function on GPU
   //vect_add<<< blocks, N >>>( a_d, b_d, N);
   vect_add<<< blocks, N >>>( a_d, b_d, N);

   // copy vectors back from GPU to CPU
   cudaMemcpy( a, a_d, sizeof(float) * N, cudaMemcpyDeviceToHost );
   //cudaMemcpy( b, b_d, sizeof(float) * N, cudaMemcpyDeviceToHost );

   // free GPU memory
   cudaFree(a_d);
   cudaFree(b_d);
   return;
}

/*
extern "C" void kernel_wrapper_cublas_saxpy(float* A, float* B, int size_A)
{

checkCudaErrors(cudaMalloc((void **) &d_A, mem_size_A));

 cublasHandle_t handle;
 checkCudaErrors(cublasCreate(&handle));
 float alpha = 1.0;
 int incx =1;
 int incy =1;
 checkCudaErrors(cublasSaxpy(handle, size_A, &alpha, d_A, incx, d_B, incy )); 

}
*/