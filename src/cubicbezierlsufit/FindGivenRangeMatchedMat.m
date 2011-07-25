% i stands for index, v stands for value
% mat1=[v11,v12,...v1m
%       ........... 
%       vn1,vn2,...vnm]
% mat2=[i1,i2,...ij
%       v1,v2,...vj]
% If kth row of mat1 that mataches values (v1,v2,...vj) at columns number
% (i1,i2,...ij) specified in mat2 then return at most (k-r)th row to (k+r)th row of mat1 as MatOut.
% where (k-r) >=1 and (k+r) <= length(mat1)
% Returns empty matrix if no row is found that matched all values
% (v1,v2,...vj).
function [MatOut]=FindGivenRangeMatchedMat(mat1,mat2,r)
MatOut=[];
k=0;
[r1 c1]=size(mat1);
[r2 c2]=size(mat2);
if (r2~=2)
    disp('Message from FindGivenRangeMatchedMat.m');
    disp('second argument matrix must have two rows');
    return
end

if (c1<c2)
    disp('Message from FindGivenRangeMatchedMat.m');
    disp('numer of columns in second argument matrix must be less than or equal to first argument matrix');
    return
end

for i=1:r1
    flag=1;
  for j=1:c2
      if( mat1(i,mat2(1,j))~=mat2(2,j) )
          flag=0;
          break;
      end      
  end
  if(flag)
      k=i; % found row with values (v1,v2,...vj)
  end
end

if (k~=0)
    x=k-r;
    y=k+r;
    if ( x < 1 )  % backward out of range so we would return from row number 1
        x=1;
    end
    if ( y > r1 ) % forward out of range so we would return until last row
        y=r1;
    end
    MatOut=mat1(x:y,:);       
end



% This function is written as an aid to get set of points in cardinal
% spline need to compute effected segment. 
% Example
%     s1    s2    s3   s4    s5   s6
% cp1---cp2---cp3---bp---cp4---cp5---cp6

% Effected Segments: s2 to s5 
% But note that
% (a) computation of s2 requires [cp1,cp2,cp3,bp] therefore we also return cp1
% (b) computation of s5 requires [bp,cp4,cp5,cp6] therefore we also return cp6


% % % --------------------------------
% % % Author: Dr. Murtaza Khan
% % % Email : drkhanmurtaza@gmail.com
% % % --------------------------------