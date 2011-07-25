close all, clc, clear all 


MxAllowSqD=20; % Max. allowed Square Distance between original and fitted data
% % % ---------------------SINE APPROXIMATION ---------------------------
x = -pi:.05:pi; x=x';
y = sin(x);   
Mat=[x,y];
ei= length(x);
ibi=[1;ei]; %first and last point are taken as initial break points

[p0mat,p1mat,p2mat,p3mat,fbi]=bzapproxu(Mat,MxAllowSqD,ibi);  


% % Now we can only save control points i.e. p0mat,p1mat,p2mat,p3mat and
% % their indices i.e. final break indices (fbi). The approxiamted (fitted)
% % data can be generated using only p0mat,p1mat,p2mat,p3mat,fbi.

% % Generating Apprxomated (Fitted data) by interpolaion
[MatI]=BezierInterpCPMatSegVec(p0mat,p1mat,p2mat,p3mat,fbi);
    
figure ,hold on
plot2d_bz_org_intrp_cp(Mat,MatI,p0mat,p1mat,p2mat,p3mat);
% ---------------------CIRCLE APPROXIMATION ---------------------------
rad=1;
theta = linspace(0, 2*pi, 300);
x = rad*cos(theta);
y = rad*sin(theta);

Mat=[x',y'];
ei= length(x);

%% initial breaks 
ibi=[1,round(ei/4),round(ei/2),round(3*ei/4),ei]; 
[p0mat,p1mat,p2mat,p3mat,fbi]=bzapproxu(Mat,MxAllowSqD,ibi);  

[MatI]=BezierInterpCPMatSegVec(p0mat,p1mat,p2mat,p3mat,fbi);
    
figure ,hold on
plot2d_bz_org_intrp_cp(Mat,MatI,p0mat,p1mat,p2mat,p3mat)
% ---------------------FIVE APPROXIMATION ---------------------------
 
Mat = dlmread('five.txt'); % read from ASCII file
ei= length(x);
ibi=[1;ei]; %first and last point

[p0mat,p1mat,p2mat,p3mat,fbi]=bzapproxu(Mat,MxAllowSqD,ibi);  

[MatI]=BezierInterpCPMatSegVec(p0mat,p1mat,p2mat,p3mat,fbi);
    
figure ,hold on
plot2d_bz_org_intrp_cp(Mat,MatI,p0mat,p1mat,p2mat,p3mat)


% % % --------------------------------
% % % Author: Dr. Murtaza Khan
% % % Email : drkhanmurtaza@gmail.com
% % % --------------------------------