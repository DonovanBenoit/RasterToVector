% % Cubic Bezier interpolation of control points based on segmentation values of
% % NVec and parameter values in vector ti.

% % INPUT:
% % Four Matrix of contol points i.e. p0mat,p1mat,p2mat,p3mat.
% % e.g. p0mat(k,:) contains  p0 of kth segment [e.g. for first segment p0mat(1,1:3)=(x0,y0,z0) ]
% % Similarly p1mat(k,:) contains  p1(x,y,z...) of kth segment
% % NVec: index vector where control points are segmented.    
% % ti: parametric values 0 to 1 for each segment. Number of values for kth
% %     segment equals to NVec(k+1)-NVec(k)+1. (Optional)
% % OUTPUT :
% % MatGlobalInterp : bezier interpolated values 

% % Example call with all arguments.
% %[MatGlobalInterp]=BezierInterpCPMatSegVec(p0mat,p1mat,p2mat,p3mat,NVec,ti)

function [MatGlobalInterp]=BezierInterpCPMatSegVec(p0mat,p1mat,p2mat,p3mat,NVec,varargin)

% % % Default Values
ti=[];
defaultValues = {ti};
% % % Assign Valus
nonemptyIdx = ~cellfun('isempty',varargin);
defaultValues(nonemptyIdx) = varargin(nonemptyIdx);
[ti] = deal(defaultValues{:});
% % ---------------------------------------------------------

niarg = nargin; %number of input arguments

MatGlobalInterp=[];
to=0;
firstSegment=1;
for k=1:length(NVec)-1   
    count=NVec(k+1)-NVec(k)+1;
    if(niarg==6)            % if ti is passsed as argument
        from=to+1;
        to  = from+count-1;
        tloc=ti(from:to);   % extracting local t from ti for kth segment 
        
    else                    % ti is not passed, using uniform parameterization
        tloc=linspace(0,1,count);        
    end
    
    %% for two adjacent segments s1 & s2, paremetric value at t=1 for s1
    %% equals t=0 for s2. Therefore no need to evaluate it. Removing t=0 
    %% from tloc from the second segment onwards.
    if (~firstSegment)
        tloc=tloc(2:end);
    end  
    
    MatLocalInterp=bezierInterp( p0mat(k,:),p1mat(k,:),p2mat(k,:),p3mat(k,:),tloc);    
    MatGlobalInterp=[MatGlobalInterp; MatLocalInterp]; % row wise concatenation
    firstSegment=0;
end


% % % --------------------------------
% % % Author: Dr. Murtaza Khan
% % % Email : drkhanmurtaza@gmail.com
% % % --------------------------------