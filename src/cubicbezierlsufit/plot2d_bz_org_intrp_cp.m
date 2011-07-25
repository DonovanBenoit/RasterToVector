% % plot original data, interpolated data, control points of bezier curve
% Mat: original data
% MatI: approximated (fitted) data
% p0mat,p1mat,p2mat,p3mat: control points

function plot2d_bz_org_intrp_cp(Mat,MatI,p0mat,p1mat,p2mat,p3mat)

lw=1; %line width

%plot(Mat(:,1),Mat(:,2),'b','Linewidth',lw);               % original data
fitted=plot(MatI(:,1),MatI(:,2),'g','Linewidth',lw);                                     % interpolated
bpx=[p0mat(:,1);p3mat(end,1)];
bpy=[p0mat(:,2);p3mat(end,2)];
bps=plot(bpx,bpy,'ro','Linewidth',lw);                                                
legend([fitted bps],'Fitted Data','Break Points','Location','SouthEast');

% plot([p1mat(:,1),p2mat(:,1)],[p1mat(:,2),p2mat(:,2)],'rd','Linewidth',lw)
% ;    % middle control points

% % % --------------------------------
% % % Author: Dr. Murtaza Khan
% % % Email : drkhanmurtaza@gmail.com
% % % --------------------------------