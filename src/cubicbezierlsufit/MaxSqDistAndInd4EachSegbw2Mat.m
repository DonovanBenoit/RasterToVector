% There are two matrices mat1 & mat2
% One can think each row of Mat as [w, x, y, z,....] i.e. each row have one
% point P=(w,x,y,z....) then mat1 and mat2 format is like following
%                               [P1;
%                                P2;
%                                P3;
%                                P4;
%                                ...
%                                PN];
% Points are segmented at indices stored in vector segIndex.
% For each segment this function finds maxium square distance and its
% corresponding golobal index (i.e. w.r.t mat1 rows (or mat2 same)).
% The algorithms is based on euclidean distance 

function [sqDistAry,indexAryGlobal]=MaxSqDistAndInd4EachSegbw2Mat(mat1,mat2,segIndex)

sqDistAry=[];
indexAryGlobal=[];

for k=1:length(segIndex)-1    
    mat1Seg=mat1(segIndex(k):segIndex(k+1),:);
    mat2Seg=mat2(segIndex(k):segIndex(k+1),:);
    [squaredmaxLocal,indexLocal]=MaxSqDistAndRowIndexbw2Mat(mat1Seg,mat2Seg);
    sqDistAry(k)=squaredmaxLocal;
    indexGlobal=indexLocal+segIndex(k)-1;        
    indexAryGlobal(k)=indexGlobal;
end


% So original boundary points are stored in mat1 and interpolated boundary
% points (parametric values) are in mat2. segIndex have indices w.r.t to
% mat1 where we do segmentation of boundary (i.e. where essentially two
% corresopding points of mat1 and mat2 intersect.


% % % --------------------------------
% % % Author: Dr. Murtaza Khan
% % % Email : drkhanmurtaza@gmail.com
% % % --------------------------------