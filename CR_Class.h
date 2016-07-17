#ifndef CR_CLASS_H
#define CR_CLASS_H

#include <vector>

class CR_Solver {
private:
    size_t diagonal_size;
    std::vector<int> sdlist;

public:
    CR_Solver(int coming_ds);
    void Solve(float * alist, float * blist, float * clist, float * dlist, float * xlist);
};


#endif
