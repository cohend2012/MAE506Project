clc
clear
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

C=[1 0 0 0];
D=[0]
%pendulum angle is calculated from the vertical line in this code(new thetha=180-old theta)
%below are desirede poles for generating desired behavior
J = [-0.799972-0.642433*i -0.799972+0.642433*i -6 -6];

K = acker(A,B,J)

% ---------- Unit-step response ----------
% ***** Enter the state matrix, control matrix, output matrix,
% and direct transmission matrix of the designed system *****
AA = A-B*K;
BB = B*K(1);
CC = [1 0 0 0];
DD = [0];
% ***** Enter step command and plot command *****
t = 0:0.01:8;
y = step(AA,BB,CC,DD,1,t);
plot(t,y)
grid
title('Unit-Step Response-Cart Position')
xlabel('t Sec')
ylabel('Cart Position')

CC2=[0 0 1 0]
t = 0:0.01:8;
y2 = step(AA,BB,CC2,DD,1,t);
figure
plot(t,y2)
grid
title('Unit-Step Response-Pendulum Angle')
xlabel('t Sec')
ylabel('Pendulum Angle')

