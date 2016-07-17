#include <cstdio>
#include "CR_Device_functions.cuh"

__global__ void list_print(int nmax, float * in) {
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    printf("Thread %i shows %f \n", i, in[i]);
}


__global__ void CR_Kernel_Forward(
    float * alist, float * blist, float * clist, float * dlist,
    int stride, int DMax) {

    int i = blockIdx.x*blockDim.x + threadIdx.x;
    int idx = stride * i;

    int pre_idx = idx - stride/2;
    int nex_idx = idx + stride/2;

    float a[] = {0.0f, 0.0f, 0.0f};
    float b[] = {0.0f, 0.0f, 0.0f};
    float c[] = {0.0f, 0.0f, 0.0f};
    float d[] = {0.0f, 0.0f, 0.0f};

    float k1, k2;

    a[1] = alist[idx];
    b[1] = blist[idx];
    c[1] = clist[idx];
    d[1] = dlist[idx];

    if (idx == 0) {

        k1 = 0.0f;
        a[2] = alist[nex_idx];
        b[2] = blist[nex_idx];
        c[2] = clist[nex_idx];
        d[2] = dlist[nex_idx];
        k2 = c[1]/b[2];


    } else if (0 == (DMax-1-i*2) ) {

        k2 = 0.0f;
        a[0] = alist[pre_idx];
        b[0] = blist[pre_idx];
        c[0] = clist[pre_idx];
        d[0] = dlist[pre_idx];
        k1 = a[1]/b[0];

    } else {

        a[0] = alist[pre_idx];
        b[0] = blist[pre_idx];
        c[0] = clist[pre_idx];
        d[0] = dlist[pre_idx];
        a[2] = alist[nex_idx];
        b[2] = blist[nex_idx];
        c[2] = clist[nex_idx];
        d[2] = dlist[nex_idx];

        k1 = a[1]/b[0];
        k2 = c[1]/b[2];

    }

    alist[idx] = -a[0]*k1;
    blist[idx] = b[1] - c[0]*k1 - a[2]*k2;
    clist[idx] = -c[2]*k2;
    dlist[idx] = d[1] - d[0]*k1 - d[2]*k2;

}

__global__ void Solve2By2(
    float * alist, float * blist, float * clist, float * dlist, float * xlist,
    int stride ) {

    int i = blockIdx.x*blockDim.x + threadIdx.x; //i = 0 or 1

    if (i == 0) {
        float k = clist[0]/blist[stride];
        xlist[0] = (dlist[0]-dlist[stride]*k)/(blist[0]-alist[stride]*k);
    } else {
        float k = blist[0]/alist[stride];
        xlist[stride] = (dlist[0]-dlist[stride]*k)/(clist[0]-blist[stride]*k);
    }

}

__global__ void CR_Kernel_Backward(
    float * alist, float * blist, float * clist, float * dlist, float * xlist,
    int stride, int DMax) {

    int i = blockIdx.x*blockDim.x + threadIdx.x;
    int idx = stride * (2*i+1);

    float xupper = xlist[idx - stride];
    float xlower = 0.0f;
    if (idx != DMax) {
        //printf("i = %i, idx = %i\n", i, idx);
        xlower = xlist[idx + stride];
    }

    xlist[idx] = (dlist[idx] - alist[idx]*xupper - clist[idx]*xlower)/blist[idx];

}
