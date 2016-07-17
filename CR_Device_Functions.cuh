#ifndef CR_Device_Functions_h
#define CR_Device_Functions_h

__global__ void list_print(int nmax, float *in);

__global__ void CR_Kernel_Forward(float * alist, float * blist, float * clist, float * dlist, int stride, int DMax);

__global__ void Solve2By2(float * alist, float * blist, float * clist, float * dlist, float * xlist, int stride);

__global__ void CR_Kernel_Backward(float * alist, float * blist, float * clist, float * dlist, float * xlist, int stride, int DMax);


#endif
