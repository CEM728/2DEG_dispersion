clear all; close all;clf

%% Data
% Data from datafile of test_case3 from the reference paper
lambda = 1550e-9;
c = 3e8;
omega = 2*pi*c/lambda;
% -143.49668392243762-I*9.517339564114454
d = lambda/4;

% Example Validations

% Material Properties
% ep1 = -143.49668392243762 -1i*9.517339564114454;
% ep2 = 1;
% ep3 = -143.49668392243762 -1i*9.517339564114454;

ep1 = -143.49668392243762;
ep2 = 1;
ep3 = -143.49668392243762;
d = lambda/4; 
% 

% EM constants
mu0 = 4*pi*1e-7;
ep0 = 8.854e-12;

% Propagations Constants
k1 = omega*sqrt(mu0*ep0*ep1);
k2 = omega*sqrt(mu0*ep0*ep2);
k3 = omega*sqrt(mu0*ep0*ep3);
%%

lxlim = 0;
uxlim = k2*10;
num = 20; %Size of the arrays
p = linspace(lxlim,uxlim,num);
root = [];
for i = 1 : length(p)
    r = newtzero(@TLGFd,p(i));
    root = vertcat(root,r);
end
% Sort the array
root = sort(root);
% Clean up roots by weeding out too close values
if ~isempty(root)
    cnt = 1;  % Counter for while loop.
    
    while ~isempty(root)
        vct = abs(root - root(1)) < 1e-1; % Minimum spacing between roots.
        C = root(vct);  % C has roots grouped close together.
        [idx,idx] = min(abs(TLGFd(C)));  % Pick the best root per group.
        rt(cnt) = C(idx); %  Most root vectors are small.
        root(vct) = []; % Deplete the pool of roots.
        cnt = cnt + 1;  % Increment the counter.
    end
    root = sort(rt).';  % return a nice, sorted column vector
end


%% Physical Roots
% Real_roots = root(real(root)>k1);
% % Plot
figure(1)
N = 5; % Number of colors to be used
% Use Brewer-map color scheme
axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')
Colord = get(gca, 'ColorOrder');

plot((real(root)/k2), (imag(root)/k2), 's', 'markersize',4,...
    'MarkerFaceColor',Colord(1,:));
hold on
% plot((real(k2)/k2) , (imag(k2)/k2), 'd', 'markersize',4,...
%     'MarkerFaceColor',Colord(2,:));
plot((real(k2)/k2) , (imag(k2)/k2), 'd', 'markersize',4,...
    'MarkerFaceColor',Colord(3,:));
% plot(real(k1)/k1 , imag(k1)/k1, 'd', 'markersize',4,...
%     'MarkerFaceColor',Colord(4,:));
% plot(real(k3)/k1 , imag(k3)/k1, 'd', 'markersize',4,...
%     'MarkerFaceColor',Colord(5,:));
% plot(real(Real_roots)/k1 , imag(Real_roots)/k1, 's', 'markersize',6,...
%     'MarkerFaceColor',Colord(5,:));
xlabel('$\Re\textrm{k}_{\rho}$','interpreter','latex')
ylabel('$\Im\textrm{k}_{\rho}$','interpreter','latex')
legend('Poles','Branch Point',...
    'Location','southwest','Orientation','horizontal');
% if nu == 0
%     title(['TE Pole Locations for thickness d = ', num2str(d), 'm']);
% else
%     title(['TM Pole Locations for thickness d = ', num2str(d), 'm']);
% end
% Decorations

box on
set(gcf,'color','white');
set(groot,'defaulttextinterpreter','latex');
set(gca,'TickLabelInterpreter', 'latex');
set(gca,...
    'box','on',...
    'FontName','times new roman',...
    'FontSize',12);
hold off

% xlim([lxlim 10*uxlim])
% ylim([-4.5e6 1e6])
% xlim([0           12000])
% ylim([-400000      600000])
% -1.9399e+09   2.7713e+08.
% 0           12000

% Save tikz figure
% cleanfigure();
% if nu == 0
%     matlab2tikz('filename',sprintf('figures/TE_pole_loc_d_%d.tex',floor(d*1e7)),'showInfo', false);
% else
%     matlab2tikz('filename',sprintf('figures/TM_pole_loc_d_%d.tex',floor(d*1e7)),'showInfo', false);
% end



%% Plot Relative Pole Locations from the Branch Point
figure(2)
N = 2; % Number of colors to be used
% Use Brewer-map color scheme
axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren');
Colord = get(gca, 'ColorOrder');
%
plot(real(root) , (imag(root)), 's', 'markersize',4,...
    'MarkerFaceColor',Colord(1,:));
hold on
plot(real(k1)  , imag(k1) , 'd', 'markersize',4,...
    'MarkerFaceColor',Colord(2,:));
%
xlabel('$\textrm{Real Relative Distance from Branch Point}$','interpreter','latex')
ylabel('$\textrm{Imaginary Relative Distance from Branch Point}$','interpreter','latex')
legend('Poles','Branch Point',...
    'Location','northeast','Orientation','horizontal');
% if nu == 0
%     title(['Relative TE Pole Locations for thickness d = ', num2str(d), 'm']);
% else
%     title(['Relative TM Pole Locations for thickness d = ', num2str(d), 'm']);
% end
% Decorations

box on
set(gcf,'color','white');
set(groot,'defaulttextinterpreter','latex');
set(gca,'TickLabelInterpreter', 'latex');
set(gca,...
    'box','on',...
    'FontName','times new roman',...
    'FontSize',12);
hold off

% Save tikz figure
% cleanfigure();
% if nu == 0
%     matlab2tikz('filename',sprintf('figures/TE_pole_rel_loc_d_%d.tex',floor(d*1e7)),'showInfo', false)
% else
%     matlab2tikz('filename',sprintf('figures/TM_pole_rel_loc_d_%d.tex',floor(d*1e7)),'showInfo', false)
% end

%% Plot Pole Verification
figure(3)
N = 2; % Number of colors to be used
% Use Brewer-map color scheme
axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')
% Obtain the colors of the plot to apply it on marker faces
Colord = get(gca, 'ColorOrder');
%
semilogy(abs(real(TLGFd(root))), 's', 'markersize',4,...
    'MarkerFaceColor',Colord(1,:));
hold on
semilogy(abs(imag(TLGFd(root))), 'o', 'markersize',4,...
    'MarkerFaceColor',Colord(2,:));
%
xlabel('$\textrm{Zero Number}$','interpreter','latex')
ylabel('$\textrm{Absolute Error}$','interpreter','latex')
legend('Real Part','Imaginary Part',...
    'Location','southeast','Orientation','horizontal');
title('Evaluation of Denominator at computed zeros');
% Decorations

box on
set(gcf,'color','white');
set(groot,'defaulttextinterpreter','latex');
set(gca,'TickLabelInterpreter', 'latex');
set(gca,...
    'box','on',...
    'FontName','times new roman',...
    'FontSize',12);
hold off

%% This is the contour plot
figure(4)
% % BS = textread([char(fname(1)) '.txt']);
X = real(root);
Y = imag(root);
Xrange = linspace(min(X),max(X),length(X));
Yrange = linspace(min(Y),max(Y),length(Y));
% 
[XI,YI] = meshgrid(Xrange,Yrange);
% 
% 
        z = abs(TLGFd(root));
        Z = griddata(X,Y,z,XI,YI,'v4');
        g = contourf(XI,YI,Z);
        colorbar;
%         title(char(mytitle(ii-1)));
%         axis equal;
%         axis tight;
%         axis off;
%         saveas(gcf,[char(fname(ii)) '.jpg'],'jpg');
% end

% Save tikz figure
% cleanfigure();
% if nu == 0
%     matlab2tikz('filename',sprintf('figures/TE_pole_discrepancy_with_nopec_d_%d.tex',floor(d*1e7)),'showInfo', false)
% else
%     matlab2tikz('filename',sprintf('figures/TM_pole_discrepancy_nopec_d_%d.tex',floor(d*1e7)),'showInfo', false)
% end
% End