
clear all;    % Clear all variables in memory
close all;    % close all figures
clc           % Clear screen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB Codes for Finite Element Analysis   %%
% 2D Barr elements                           %%
% HAMZA DJELOUD  2020                        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

E = 30e6;  % E; modulus of elasticity
A = 2;     % A: area of cross section
EA = E*A;

%load the coordinates and connectivities from external mesh software is very recommended
connectivity=load('connectivity.txt');
%elementNodes = [1 2;1 3;1 4];
nodeCoordinates=load('nodeCoordinates.txt');
%nodeCoordinates = [0 0;0 120;120 120;120 0];

numberElements =size(connectivity,1);    % 3 Number of nodes:
numberNodes =   size(nodeCoordinates,1); % 4 Number of elements:


xx = nodeCoordinates(:,1);
yy = nodeCoordinates(:,2);

% for structure:


%   stiffness: stiffness matrix
GDof = 2*numberNodes;               % GDof: total number of degrees of freedom
displacements = zeros(GDof,1);      % displacements: displacement vector
force = zeros(GDof,1);              % force : force vector

% applied load at node 2
force(2) = -10000.0;
%%
for i_el=1:numberElements % 3 Number of elements
    
    i = connectivity(i_el, 1);
    j = connectivity(i_el, 2);
    
    xi = nodeCoordinates(i, 1); 
    yi = nodeCoordinates(i, 2);
    xj = nodeCoordinates(j, 1); 
    yj = nodeCoordinates(j, 2);
    
[L,T] = transformation_matrix(xi,yi,xj,yj)

[Ke,Keg] = PlaneTruss_Element_Stiffness(E,A,L, T)
%KK = PlaneTrussAssemble(K,Stiffness_Matrix,i,j);
%K = PlaneTrussAssemble(K,Stiffness_Matrix,i,j)
stiffness=assemble(i,j,Keg,GDof)
end
% computation of the system stiffness matrix
% [stiffness] = ...
%     formStiffness2Dtruss(GDof,numberElements, ...
%     elementNodes,numberNodes,nodeCoordinates,xx,yy,EA);

10;
%%
% boundary conditions and solution
prescribedDof = [3:8]';

% solution
displacements = solution(GDof,prescribedDof,stiffness,force);

% drawing displacements
us = 1:2:2*numberNodes-1;
vs = 2:2:2*numberNodes;

figure
L = xx(2)-xx(1);
XX = displacements(us); YY = displacements(vs);
dispNorm = max(sqrt(XX.^2+YY.^2));
scaleFact = 15000*dispNorm;
hold on
drawingMesh(nodeCoordinates+scaleFact*[XX YY],connectivity, ...
    'L2','k.-');
drawingMesh(nodeCoordinates,connectivity,'L2','k.--');
axis equal
set(gca,'fontsize',18)

% stresses at elements
stresses2Dtruss(numberElements,connectivity, ...
    xx,yy,displacements,E)

% output displacements/reactions
outputDisplacementsReactions(displacements,stiffness, ...
    GDof,prescribedDof)
