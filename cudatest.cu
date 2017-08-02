#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda.h>
#include <cuda_runtime.h>

// simple kernel function that adds two vectors
// originally used for demonstration
__global__ void vect_add(float *a, float *b, int N)
{
   int idx = threadIdx.x;
   if (idx<N) a[idx] = a[idx] + b[idx];
}

__global__ void vectorAdd(float *a, float *b, int N)
{
int i = blockDim.x*blockIdx.x + threadIdx.x;
if(i < N) a[i] = a[i] + b[i];
}

//function to call from FORTRAN
extern "C" void vectoraddwrapper_( float *a, float *b, int *Np)
{
cudaError_t err = cudaSuccess;
int N = *Np;       // number of elements

size_t size = N*sizeof(float);

float *d_a = NULL;
err = cudaMalloc((void **)&d_a, size);
//error check
if(err != cudaSuccess)
{
fprintf(stderr,"Failed to allocate memory for vector A! \n");
exit(EXIT_FAILURE);
}

float *d_b = NULL;
err = cudaMalloc((void **)&d_b, size);
//error check
if(err != cudaSuccess)
{
fprintf(stderr,"Failed to allocate memory for vector B! \n");
exit(EXIT_FAILURE);
}

//copying value from host
err = cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
err = cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

//setting up computation kernel
int threadsPerBlock = 1; //require testing
int blocksPerGrid =(N + threadsPerBlock - 1) / threadsPerBlock;
vectorAdd<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b, N);

//copy result
err = cudaMemcpy(a, d_a, size, cudaMemcpyDeviceToHost);
//error check
if(err != cudaSuccess)
{
fprintf(stderr,"Failed to copy result for vector A! \n");
exit(EXIT_FAILURE);
}

cudaFree(d_a);
cudaFree(d_b);
printf("Test passed!\n");

}
