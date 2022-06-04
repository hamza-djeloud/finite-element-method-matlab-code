function [L,T] = transformation_matrix(xi,yi,xj,yj)


L = sqrt((xi-xj)^2+(yi-yj)^2); % length element
    C = (xi-xj)/L;
    S = (yi-yj)/L;
    
    T=[C    -S  0   0
       S    C   0   0
       0    0   C   -S
       0    0   S   C];