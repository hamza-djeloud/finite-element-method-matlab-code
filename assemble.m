function stiffness=assemble(i,j,Keg,GDof)

stiffness=zeros(GDof);

elementDof=[2*i-1 2*i 2*j-1 2*j];

stiffness(elementDof,elementDof) =stiffness(elementDof,elementDof)+Keg;
