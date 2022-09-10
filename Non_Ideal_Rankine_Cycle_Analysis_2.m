clear
clc
%% Name and Id Number 
fprintf('Name: Yoseph Tekle Gebra \nId No: 2018508134 \n')
%% SIMPLE RANKINE CYCLE 
%%

% This code shows the ploting method of our Basic Ideal Rankine cycle

m_dot=1; %mdot in kg/s

% The Pressure at the inlet of the Turbine 'P1'
P1=80;

To=300;  % The ambient Temperature in K
Po=2; % The ambient Pressure
%% Efficiency of the Turbine and the Pump respectively 
E_T=0.85;
E_p=0.85;


%% State One
T1=XSteam('Tsat_p',P1);
S1=XSteam('sV_p',P1);
h1=XSteam('hV_p',P1);
u1=XSteam('uV_p',P1);
v1=XSteam('vV_p',P1);

%%  State Two Ideal
S2s=S1;
P2=0.08;
T2s=XSteam('T_ps',P2,S2s);
h2s=XSteam('h_ps',P2,S2s);
u2s=XSteam('u_ps',P2,S2s);
v2s=XSteam('v_ps',P2,S2s);
x2s=XSteam('x_ps',P2,S2s);

%%  State Two Real
h2a=h1-E_T*(h1-h2s);

T2a=XSteam('T_ph',P2,h2a);
s2a=XSteam('s_ph',P2,h2a);
u2a=XSteam('u_ph',P2,h2a);
v2a=XSteam('v_ph',P2,h2a);
x2a=XSteam('x_ph',P2,h2a);

%% State Three
P3=P2;
T3=XSteam('Tsat_p',P3);
s3=XSteam('sL_p',P3);
h3=XSteam('hL_p',P3);
u3=XSteam('uL_p',P3);
v3=XSteam('vL_p',P3);

%% State Four Ideal
P4=80;
s4s=s3;
T4s=XSteam('T_ps',P4,s4s);
h4s=XSteam('h_ps',P4,s4s);
u4s=XSteam('u_ps',P4,s4s);
v4s=XSteam('v_ps',P4,s4s);

%% State Four Real
P4=80;
h4a=h3+(h4s-h3)/E_p;
T4a=XSteam('T_ph',P4,h4a);
s4a=XSteam('s_ph',P4,h4a);
u4a=XSteam('u_ph',P4,h4a);
v4a=XSteam('v_ph',P4,h4a);

%% Thermal Efficiency
Qin=m_dot*(h1-h4a);         % Heat input to the system       kW
Wt=m_dot*(h1-h2a);          % Work of the Turbine            kW
Wp=m_dot*(h4a-h3);          % Work of the Pump               kW
W_Cycle = m_dot*(Wt-Wp);    % Total Work of the cycle        kW
E=(W_Cycle)/Qin;            % Efficiency of the cycle        kW



%% Exergy Analysis
To=300; % Ambiant Temperature used at K
Po=2; % Ambiant Pressure used 

%  Exergy analysis of Turbine
exf_turbine= m_dot*((h2a-h1) - To*(s2a-S1));
ex_turbine_destruction= m_dot*(To*(s2a-S1));

%  Exergy analysis of condenser
exf_condenser= m_dot*((h2a-h3) - To*(s2a-s3));
ex_condenser_destruction=m_dot*(To*(s2a-s3));


%  Exergy analysis of pump
exf_pump= m_dot*((h4a-h3) - To*(s4a-s3));
ex_pump_destruction=m_dot*(To*(s4a-s3));

%  Exergy analysis of Boiler
exf_Boiler= m_dot*((h1-h4a) - To*(S1-s4a));
ex_boiler_destruction=m_dot*(To*(S1-s4a));


%% Ploting Initializations

T_lim=350; % Temperature limit used for the pressure curve


% Bellow we analyised the phenomena of our cycle and the pressure lines of
% the Basic Rankine Cycle


n = linspace(T3,T_lim,500);

t=linspace (0,550,500);

s1_concat=[];
for i = 1:length(n)
   s_Generated_1=XSteam('s_pT', P1,n(i));
    s1_concat=[s1_concat s_Generated_1];
end
T_d=T3-5;
m = linspace(T_d,100);
s2_concat=[];
for i = 1:length(m)
   s_Generated_2=XSteam('s_pT', P2,m(i));
    s2_concat=[s2_concat s_Generated_2];
end




% Saturation curve procedures 

sat_curve_h=[];
sat_curve_t=[];
for i = 1:length(t)
    s_saturation_1=XSteam('sL_T',t(i));
    s_saturation_2=XSteam('sV_T',t(i));
    sat_curve_h=[sat_curve_h s_saturation_1];
    sat_curve_t=[sat_curve_t s_saturation_2];
end



%% Plotting The Values

figure(1)
%Ploting state 1 points
plot(S1,T1, 'marker','x')
hold on
%Ploting state 2 points fro real envýronment
plot(s2a,T2a, 'marker','x')
%Ploting state 2 points for the ýsentropýc envýronment 
plot(S2s, T2s, 'marker', 'x')
%Ploting state 3 points
plot(s3,T3, 'marker', 'x')
%Ploting state 4 points for the real envýronment 
plot(s4a, T4a, 'marker', 'x')
%Ploting state 4 points for the ýsentropýc envýronment 
plot(s4s, T4s, 'marker', 'x')
%Ploting state 1 to 2
plot ([S1 S2s], [T1 T2s], 'marker','x','color', 'black','LineWidth',1)
plot ([S1 s2a], [T1 T2a], 'marker','x','color', 'black','LineWidth',2)
%Ploting state 2 to 3
plot([S2s s3], [T2s T3], 'marker','x','color', 'black','LineWidth',2)
%Ploting state 3 to 4
plot ([s3 s4s], [T3 T4s], 'marker','x','color','black','LineWidth',1)
plot ([s3 s4a], [T3 T4a], 'marker','x','color','black','LineWidth',2)
%Plot the ts of water in liquid
plot(sat_curve_h,t, 'marker','.','color','b')
%Plot the ts of water in Vapour
%Plot the ts of water in Vapour
plot(sat_curve_t,t, 'marker','.','color','b')
plot(s1_concat,n, 'color', 'r','LineWidth',1)
plot(s2_concat,m, 'color', 'r','LineWidth',1)
text(s4s,T4s,'\leftarrow 4s')
text(s4a,T4a,'\leftarrow 4a')
text(s3,T3,'\rightarrow 3')
text(S2s,T2s,'\rightarrow 2s')
text(s2a,T2a,'\rightarrow 2a')
text(S1,T1,'\rightarrow 1')
title('Rankine Cycle T-S Diagram')
grid on
grid minor
xlabel('S')
ylabel('T')
hold off

%% Exergy Change of the system
EEE= (u4a-u1)+ Po*(v4a-v1)-To*(s4a-S1);
