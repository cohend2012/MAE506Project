%Daniel Cohen 
% Final Project MAE 506

m = 1;
M = 5;
L = 2;
g = -9.81;
d = 1;


% A matrix we cited in our proposal
A = [0 1 0 0;
    0 -d/M -m*g/M 0;
    0 0 0 1;
    0 -d/(M*L) -(m+M)*g/(M*L) 0];


% B matrix we cited in our proposal
B = [0; 1/M; 0; 1/(M*L)];
open_eigs=eigs(A) % look at the eigs 

% posible Q 
% Q = [1 0 0 0; 
%     0 10 0 0;
%     0 0 100 0;
%     0 0 0 1000];

Q = eye(4)

%Q = [100 0 0 0; 
   % 0 10 0 0;
   % 0 0 10 0;
   % 0 0 0 1];


%Q = eye(size(A));
% Posible R
R = eye(1)*0.1;
%R = eye(1)*1;
syms s KP1 KD1 KP2 KD2
K_Vec = [KP1 KD1 KP2 KD2]
full_system = (s*eye(size(A))-A-B*K_Vec)
C = [1 1 1 1];
full_system_com = [1 1 1 1]*((s*eye(size(A))-A)^-1)*B
simplify(full_system_com)
det(full_system)

% unstable
det((s*eye(size(A))-A))


solve((s*(- 1000*s^3 - 200*s^2 + 5886*s + 981))==0)

ACCF = [ 0 1 0 0;
         0 0 1 0;
         0 0 0 1;
         0 981/1000  5886/1000 -200/1000]
BCCF = [0 ;0 ;0 ;1]
CCCF = [981 981 -300 -300]
     
 Top = full_system(1:2,1:2)

 det(Top)
 
 Bot = full_system(3:4,3:4)
 
 det(Bot)
 
 percet_os = 2/100;
 
 Ts = 5;
 zeta_des = -log(percet_os)/sqrt(pi^2+log(percet_os)^2)
 wn_des = 4/(zeta_des*Ts)
 
 KD1_gain = solve(1/5- (KD1)/5 ==2*zeta_des*wn_des)
 
 KP1_gain  = solve(-KP1/5 == wn_des^2)
 
     
 KD2_gain = solve(- (KD2)/10 ==2*zeta_des*wn_des)
 
 KP2_gain  = solve(- KP2/10 - 2943/500 == wn_des^2)
 
 s^2 +2*zeta_des*wn_des*s+wn_des^2 
 
 
 KccF = [67.3728+0 119.243+(981/1000) 90.6527+(5886/1000) 17.6000-(200/1000) ]
 
 syms s
 U = det(s*eye(length(A))-A);
 
 PCCF_INV = [-(981)/1000 (-2943/500) 1/5 1;... 
             (-2943/500) 1/5 1 0;...
             1/5 1 0 0;...
             1 0 0 0];
 

 
%%
det(ctrb(A,B)) % Can we control it 





%%
K = lqr(A,B,Q,R); % If we used the classic LQR what would our gain look like for each state space var
CLP = eig(A-B*K)
tspan = 0:.001:20;
%tspan = linspace(0,10,10000); % time 

y0 = [-3; 0; pi+.1; 0]; % [x xdot theta theta_dot]
[t,y] = ode45(@(t,y)((A-B*K)*(y-[0; 0; pi; 0])),tspan,y0); % LQR sol
%[t,y] = ode45(@(t,y)((A*y)),tspan,y0) % un controled

%systrem
gain_1 = -1; 
gain_2 = 0;
gain_3 = 0;
gain_4 = 0;

alpha = 0.1;

%mse of the system 
% TO DO:
% Calc time to settle 
% Calc percent overshoot
% Calc engery used or tau over time


% working on mor conplex stuff for fun. like doing graidaint decent to find
% gain



%[t,y] = ode45(@(t,y)(([gain_1 gain_2 gain_3 gain_4]').*(y-[0; 0; pi; 0])),tspan,y0)

non_norm_mse = [0 ;0; 0; 0];

for time_stamp = 1:length(tspan)
    
    non_norm_mse= non_norm_mse+(transpose(y(time_stamp,:))-[0; 0; pi; 0]).^2;
    
end

norm = length(tspan);

mse = non_norm_mse/norm;


score = (mse'*mse);





figure(1)


% TO DO: 
% MAKE A VIDEO FOR THE PPTX WE NEED
% 
 %v = VideoWriter('LQR.avi');
 %open(v)



% Recomend to dock this system to watch it 
 for k=1:100:length(t)
     
     drawcartpend_bw(y(k,:),m,M,L);
     %frame = getframe(gcf);
     %writeVideo(v,frame);
  
 end
 %close(v)
 
 

% Clean Plot of the system
% TO DO:
% Seperate all plot on the same figs
figure(2)
hold on;  set(gca,'Fontsize',10); %axis square;
%xlabel('Time (s)'); ylabel('Output'); 

%plot(tspan,y,'Linewidth',2)


% EXAMPLE from my thesis
%title('LQR Soultion')
subplot(4,1,1);
plot(tspan, y(:,1), 'r-','LineWidth',2);
xlabel('$t$ (s)', 'Interpreter','latex')  
ylabel('$x$ (m)', 'Interpreter','latex');
% 
hold on;  set(gca,'Fontsize',10,'fontname','Times','FontWeight','bold');
title('LQR Soultion')
grid on
 subplot(4,1,2);
plot(tspan, y(:,2), 'r-','LineWidth',2);
xlabel('$t$ (s)', 'Interpreter','latex')  
ylabel('$v$ (m/s)', 'Interpreter','latex');
% 
hold on;  set(gca,'Fontsize',10,'fontname','Times','FontWeight','bold');
grid on
subplot(4,1,3);
plot(tspan, y(:,3), 'b-','LineWidth',2);
xlabel('$t$ (s)', 'Interpreter','latex')  
ylabel('$\theta$ (rad)', 'Interpreter','latex');
% 
hold on; set(gca,'Fontsize',10,'fontname','Times','FontWeight','bold');
grid on
subplot(4,1,4);
plot(tspan, y(:,4), 'b-','LineWidth',2);
xlabel('\bf{$t$ (s)}', 'Interpreter','latex')  
ylabel('\bf{$\omega$ (rad/s)}', 'Interpreter','latex');
hold on;  set(gca,'Fontsize',10,'fontname','Times','FontWeight','bold');
set(gcf,'color','white')
grid on


% ylabel('$y$', 'Interpreter','latex')  
% legend('Closed−Loop')
% set(gca,'linewidth',2,'fontsize',20,'fontname','Times');
% set(gcf,'color','white')
% grid on

S_LQR = stepinfo(y,tspan,[0; 0; pi; 0])

sys_LQR  = ss(A-B*K,B,C,0)
% needs new fig
%step(sys_LQR)

stepinfo(sys_LQR)



%%
% PD Ctrl


%K_PD(1:2)= [-4 -20];
%K_PD(3:4)  =[300 170];


%K_PD = [ KP1_gain KD1_gain KP2_gain KD2_gain]

ACCF = [ 0 1 0 0;
         0 0 1 0;
         0 0 0 1;
         0 981/1000  5886/1000 -200/1000]
BCCF = [0 ;0 ;0 ;1]
CCCF = [981 981 -300 -300]

 %K_PD = [-5 -20  300 160]
 
 
 
 KccF = [67.3728+0 119.243+(981/1000) 90.6527+(5886/1000) 17.6000-(200/1000) ]
 
 
 %K = KccF*(ctrb(A,B)*PCCF_INV)^-1 % dan Cohen calc of gain for pd
 
 
 K =[-38.6303  -72.5903  698.6406  279.1800]
%[t,y] = ode45(@(t,y)((ACCF-BCCF*KccF)*(y-[0; 0; pi; 0])),tspan,y0); 


[t,y] = ode45(@(t,y)((A-B*K)*(y-[0; 0; pi; 0])),tspan,y0); 
% Recomend to dock this system to watch it 

figure(3)
%v2 = VideoWriter('PD.avi');
%open(v2)
% Recomend to dock this system to watch it 
 for k=1:100:length(t)
     drawcartpend_bw(y(k,:),m,M,L);
     %frame = getframe(gcf);
     %writeVideo(v2,frame);
     
 end
 
 %close(v2)

figure(4)
hold on;  set(gca,'Fontsize',10,'fontname','Times'); %axis square;
%xlabel('Time (s)'); ylabel('Output'); 

%plot(tspan,y,'Linewidth',2)


%
%title('PD')
subplot(4,1,1);
plot(tspan, y(:,1), 'r-','LineWidth',2);
xlabel('\bf{$t$ (s)}', 'Interpreter','latex')  
ylabel('$x$ (m)','Interpreter','latex');
% 
hold on;  set(gca,'Fontsize',10,'fontname','Times','FontWeight','bold');
title('PD Soultion')
grid on
 subplot(4,1,2);
plot(tspan, y(:,2), 'r-','LineWidth',2);
xlabel('\bf{$t$ (s)}', 'Interpreter','latex') 
ylabel('$v$ (m/s)','Interpreter','latex');
% 
hold on;  set(gca,'Fontsize',10,'fontname','Times','FontWeight','bold');
grid on
subplot(4,1,3);
plot(tspan, y(:,3), 'b-','LineWidth',2);
xlabel('\bf{$t$ (s)}', 'Interpreter','latex')   
ylabel('$\theta$ (rad)','Interpreter','latex');
% 
hold on;  set(gca,'Fontsize',10,'fontname','Times','FontWeight','bold');
grid on
subplot(4,1,4);
plot(tspan, y(:,4), 'b-','LineWidth',2);
xlabel('\bf{$t$ (s)}', 'Interpreter','latex') 
ylabel('$\omega$ (rad/s)','FontWeight','bold', 'Interpreter','latex','fontsize',10);
hold on;  set(gca,'Fontsize',10,'fontname','Times','FontWeight','bold');
set(gcf,'color','white')
grid on


S_PD = stepinfo(y,tspan,[0; 0; pi; 0])

S_PD_ss  = ss(A-B*K,B,C,0)
% need Another plot
%step(S_PD_ss)

stepinfo(S_PD_ss)


%% Observer

OB = obsv(A,C)

det(OB)


% Simulation of an observer−based compensator
%tspan = [0 tspan]; % time horizon
xAin = y0; % actual state vector at the initial time
xEin = y0%[-3.1;0;3.1;0]; % estimate of state vector at the initial time
xin = [xAin; xEin];

det(s*eye(length(A))-A)

 s^2 +2*zeta_des*wn_des*s+wn_des^2 
 
 s^4+(176/5)*s^3+(727327/2000)*s^2+(123454/125)*s+(168432/125)
 
  
 s^4+35.2*s^3+363.6635*s^2+987.6320*s+1347.5 
 
 %PCCF_INV found before
 
 LOCF = [1347.5+0;987.6320+(981/1000);363.6635+(5886/1000);35.2-(200/1000)]

L = ((PCCF_INV*OB)^-1)*LOCF

 
 KccF = [67.3728+0 119.243+(981/1000) 90.6527+(5886/1000) 17.6000-(200/1000) ]



[t,y] = ode45(@solveObsBasedComp,tspan,xin); 






figure(5)
 for k=1:100:length(t)
     drawcartpend_bwOBVCTR(y(k,:),m,M,2);
     %frame = getframe(gcf);
     %writeVideo(v2,frame);
     
 end
 
 
 
 
figure(6)
hold on;  set(gca,'Fontsize',10,'fontname','Times'); %axis square;
%xlabel('Time (s)'); ylabel('Output'); 

%plot(tspan,y,'Linewidth',2)


%
%title('OBSVCTRL')
subplot(4,1,1);
plot(tspan, y(:,1), 'r-','LineWidth',2);
xlabel('\bf{$t$ (s)}', 'Interpreter','latex')  
ylabel('$x$ (m)','Interpreter','latex');
% 
hold on;  set(gca,'Fontsize',10,'fontname','Times','FontWeight','bold');
title('Observer Based Compensator')
grid on
 subplot(4,1,2);
plot(tspan, y(:,2), 'r-','LineWidth',2);
xlabel('\bf{$t$ (s)}', 'Interpreter','latex') 
ylabel('$v$ (m/s)','Interpreter','latex');
% 
hold on;  set(gca,'Fontsize',10,'fontname','Times','FontWeight','bold');
grid on
subplot(4,1,3);
plot(tspan, y(:,3), 'b-','LineWidth',2);
xlabel('\bf{$t$ (s)}', 'Interpreter','latex')   
ylabel('$\theta$ (rad)','Interpreter','latex');
% 
hold on;  set(gca,'Fontsize',10,'fontname','Times','FontWeight','bold');
grid on
subplot(4,1,4);
plot(tspan, y(:,4), 'b-','LineWidth',2);
xlabel('\bf{$t$ (s)}', 'Interpreter','latex') 
ylabel('$\omega$ (rad/s)','FontWeight','bold', 'Interpreter','latex','fontsize',10);
hold on;  set(gca,'Fontsize',10,'fontname','Times','FontWeight','bold');
set(gcf,'color','white')
grid on


OBS_PD = stepinfo(y,tspan,[0; 0; pi; 0])

S_OBS_ss  = ss(A-B*K,B,C,0)
% need Another plot
%step(S_PD_ss)

stepinfo(S_OBS_ss)






function dx = solveObsBasedComp(t,x)
m = 1;
M = 5;
L = 2;
g = -9.81;
d = 1;


% A matrix we cited in our proposal
A = [0 1 0 0;0 -d/M -m*g/M 0;0 0 0 1;0 -d/(M*L) -(m+M)*g/(M*L) 0];


% B matrix we cited in our proposal
B = [0; 1/M; 0; 1/(M*L)];
C = [1 1 1 1];
D=0;
L = [114.0519; -219.4375; 54.8730 ;85.5126];
K = [-38.6303  -72.5903  698.6406  279.1800];
r = 0;
G=1;
dx = [A -B*K; L*C A-B*K-L*C]*x + [B*G; B*G]*r;
end



function dy = cartpend(y,m,M,L,g,d,u)
% unused 
Sy = sin(y(3));
Cy = cos(y(3));
D = m*L*L*(M+m*(1-Cy^2));

dy(1,1) = y(2);
dy(2,1) = (1/D)*(-m^2*L^2*g*Cy*Sy + m*L^2*(m*L*y(4)^2*Sy - d*y(2))) + m*L*L*(1/D)*u;
dy(3,1) = y(4);
dy(4,1) = (1/D)*((m+M)*m*g*L*Sy - m*L*Cy*(m*L*y(4)^2*Sy - d*y(2))) - m*L*Cy*(1/D)*u +.01*randn;
end


function drawcartpend_bw(y,m,M,L)

% Funtion for drawing made by Steve Brunton 
% Data Driven Machine learning book
x = y(1);
th = y(3);

% kinematics
% x = 3;        % cart position
% th = 3*pi/2;   % pendulum angle

% dimensions
% L = 2;  % pendulum length
W = 1*sqrt(M/5);  % cart width
H = .5*sqrt(M/5); % cart height
wr = .2; % wheel radius
mr = .3*sqrt(m); % mass radius

% positions
% y = wr/2; % cart vertical position
y = wr/2+H/2; % cart vertical position
w1x = x-.9*W/2;
w1y = 0;
w2x = x+.9*W/2-wr;
w2y = 0;

px = x + L*sin(th);
py = y - L*cos(th);

plot([-10 10],[0 0],'w','LineWidth',2)
hold on
rectangle('Position',[x-W/2,y-H/2,W,H],'Curvature',.1,'FaceColor',[1 0.1 0.1],'EdgeColor',[1 1 1])
rectangle('Position',[w1x,w1y,wr,wr],'Curvature',1,'FaceColor',[1 1 1],'EdgeColor',[1 1 1])
rectangle('Position',[w2x,w2y,wr,wr],'Curvature',1,'FaceColor',[1 1 1],'EdgeColor',[1 1 1])

plot([x px],[y py],'w','LineWidth',2)

rectangle('Position',[px-mr/2,py-mr/2,mr,mr],'Curvature',1,'FaceColor',[.3 0.3 1],'EdgeColor',[1 1 1])

% set(gca,'YTick',[])
% set(gca,'XTick',[])
xlim([-5 5]);
ylim([-2 2.5]);
set(gca,'Color','k','XColor','w','YColor','w')
set(gcf,'Position',[10 900 800 400])
set(gcf,'Color','k')
set(gcf,'InvertHardcopy','off')
xlim('manual')
ylim('manual')

% box off
drawnow
hold off

end

function drawcartpend_bwOBVCTR(y,m,M,L)

% Funtion for drawing made by Steve Brunton 
% Data Driven Machine learning book
x = y(1);
th = y(3);

% kinematics
% x = 3;        % cart position
% th = 3*pi/2;   % pendulum angle

% dimensions
% L = 2;  % pendulum length
W = 1*sqrt(M/5);  % cart width
H = .5*sqrt(M/5); % cart height
wr = .2; % wheel radius
mr = .3*sqrt(m); % mass radius

% positions
% y = wr/2; % cart vertical position
y = wr/2+H/2; % cart vertical position
w1x = x-.9*W/2;
w1y = 0;
w2x = x+.9*W/2-wr;
w2y = 0;

px = x + L*sin(th);
py = y - L*cos(th);

plot([-10 10],[0 0],'w','LineWidth',2)
hold on
rectangle('Position',[x-W/2,y-H/2,W,H],'Curvature',.1,'FaceColor',[1 0.1 0.1],'EdgeColor',[1 1 1])
rectangle('Position',[w1x,w1y,wr,wr],'Curvature',1,'FaceColor',[1 1 1],'EdgeColor',[1 1 1])
rectangle('Position',[w2x,w2y,wr,wr],'Curvature',1,'FaceColor',[1 1 1],'EdgeColor',[1 1 1])

plot([x px],[y py],'w','LineWidth',2)

rectangle('Position',[px-mr/2,py-mr/2,mr,mr],'Curvature',1,'FaceColor',[.3 0.3 1],'EdgeColor',[1 1 1])

% set(gca,'YTick',[])
% set(gca,'XTick',[])
xlim([-5 5]);
ylim([-2 2.5]);
set(gca,'Color','k','XColor','w','YColor','w')
set(gcf,'Position',[10 900 800 400])
set(gcf,'Color','k')
set(gcf,'InvertHardcopy','off')
xlim('manual')
ylim('manual')

% box off
drawnow
hold off

end




