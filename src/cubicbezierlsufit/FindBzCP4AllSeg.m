% % Find Cubic Bezier Control Points of given segments
% % INPUT:
% % Mat: Input data such that Mat(k,:) holds kth point.
% %      Points can be in N-D vector space i.e. 1D, 2D,3D or ND
% % SegIndexIn: Indix with respect to Mat where points are segmented.
% % ptype: if 'u' or 'unform' then uniform parameterizaton is used , 
% %        otherwise chord-length parameterizaton is used.
% % OUTPUT
% % p0mat,p1mat,p2mat,p3mat: control point matrices such that p*mat(k,:)
% %                          holds Control Points of kth Segment.   
% % tout: parameter 't' value for all segments
function [p0mat,p1mat,p2mat,p3mat,tout]=FindBzCP4AllSeg(Mat,SegIndexIn,varargin)

%%% Default Values %%%
ptype='';
defaultValues = {ptype};
%%% Assign Valus %%%
nonemptyIdx = ~cellfun('isempty',varargin);
defaultValues(nonemptyIdx) = varargin(nonemptyIdx);
[ptype] = deal(defaultValues{:});
%%%------------------------------

tout=[];
for k=1:length(SegIndexIn)-1
    fromRow=SegIndexIn(k);
    toRow=SegIndexIn(k+1);
    size(Mat(fromRow:toRow,:));
    if (strcmpi(ptype,'u') || strcmpi(ptype,'uniform') )
        [p0,p1,p2,p3,t]= FindBezierControlPointsND(Mat(fromRow:toRow,:),'u'); %uniform parameterization
    else
        [p0,p1,p2,p3,t]= FindBezierControlPointsND(Mat(fromRow:toRow,:));    %chord-length parameterization
    end   

    p0mat(k,:)=p0; 
    p1mat(k,:)=p1;
    p2mat(k,:)=p2;
    p3mat(k,:)=p3;
    tout=horzcat(tout,t);
end

% % % --------------------------------
% % % Author: Dr. Murtaza Khan
% % % Email : drkhanmurtaza@gmail.com
% % % --------------------------------