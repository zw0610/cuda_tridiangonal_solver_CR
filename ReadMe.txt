Hello, Thank you for using the Tridiagonal Solver with Cyclic Reduction in CUDA

1. To solve a Tridiagonal Equation:
  A * x = B,
where, A =     a1 | b1 c1  0  0  ...  0  0  |         x = | x1 |             B = | d1 |
                  | a2 b2 c2  0  ...  0  0  |             | x2 |                 | d2 |
                  |  0 a3 b3 c3  ...  0  0  |             | x3 |                 | d3 |
                  |  0  0 a4 b4  ...  0  0  |             | x4 |                 | d4 |
                  |           ...           |             | .. |                 | .. |
                  |  0  0  0  0  ... an bn  | cn          | xn |                 | dn |
                  
                  a1 = cn = 0
size(a) = (n,n);  size(x) = (n,1);  size(B) = (n,1);

2. To create an instance of, please use CR_Solver(n) function, where n is the size of the square matrix A.
  CR_Solver crs = CR_Solver(24);

3. Prepare (A), (x), (B) with (alist, blist, clist), (xlist), (dlist)
  ptr_alist = [a1, a2, ... , an]
  ptr_blist = [b1, b2, ... , bn]
  ptr_clist = [c1, c2, ... , cn]
  ptr_dlist = [d1, d2, ... , dn]
  ptr_xlist = [x1, x2, ... , xn]
  ptr_ilist should be array on device
  
4. To solve the equation, please use the Solve() function.
  crs.Solve(ptr_alist, ptr_blist, ptr_clist, ptr_dlist, ptr_xlist);


