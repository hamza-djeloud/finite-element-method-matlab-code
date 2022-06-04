function [Ke,Keg] = PlaneTruss_Element_Stiffness(E,A,L, T)

Ke=A*E/L*[1  0   -1  0
         0   0   0   0
         -1  0   1   1
         0   0   0   0];
     Keg=T'*Ke*T;
