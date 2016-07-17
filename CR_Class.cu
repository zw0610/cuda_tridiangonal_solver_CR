#include "CR_Class.h"
#include "CR_Device_functions.cuh"

CR_Solver::CR_Solver(int coming_ds) {

    diagonal_size = coming_ds;

    int stride = 0;
    int current_size = diagonal_size;
    for (stride=2; stride <diagonal_size; stride *= 2) {
        sdlist.push_back(current_size);
        current_size = (current_size+1)/2;
    }
    sdlist.push_back(2);

}


void CR_Solver::Solve(float * alist, float * blist, float * clist, float * dlist, float * xlist) {

    int next_size;
    int current_size = diagonal_size;
    int stride=2;
    for (; stride <diagonal_size; stride *= 2) {
        next_size = (current_size+1)/2;
        CR_Kernel_Forward<<<1,next_size>>>(alist, blist, clist, dlist, stride, current_size);
        //cudaDeviceSynchronize();
        current_size = next_size;
    }

    Solve2By2<<<1,2>>>(alist, blist, clist, dlist, xlist, stride/2);

    int neo_stride = stride/4;
    for (int id = (sdlist.size()-1); id>0; id--) {
        int even_number = sdlist[id-1] - sdlist[id];
        int last_index = (sdlist[id-1]-1)*neo_stride;
        CR_Kernel_Backward<<<1,even_number>>>(alist, blist, clist, dlist, xlist, neo_stride, last_index);
        neo_stride = neo_stride/2;
    }



}
