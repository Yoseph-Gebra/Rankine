clear
clc
%% Name and Id Number 
fprintf('Name: Yoseph Tekle Gebra \nId No: 2018508134 \n')

%% RE-GENERATIVE RANKINE CYCLE ANLYSIS
%%

% IN THE FOLLOWING CODE, WE ANALYISE THE EFFECT OF A REGENERATIVE ON A
% SIMPLE RANKINE CYCLE. WE THEN COMPARED OUR SIMPLE RANKINE CYCLE AND THE
% REGENERATIVE CYCLE BASED ON THEIR EFFICIENY AND EXERGY DESTRUCTION

%% Initial Given Values

% The total mass pers unit second 
m_dot=1;

% The given temperature at the Turbine
T1=480;

% Inital values taken for the Turbine inlet and outlet at both exits.
P1=80;
P2=7;
P3=0.08;

%% Efficiency Values
E_T=0.85;
E_P_1=0.85;
E_P_2=0.85;

%% State One

s1=XSteam('s_pT',P1,T1);
h1=XSteam('h_pT',P1,T1);
u1=XSteam('u_pT',P1,T1);
v1=XSteam('v_pT',P1,T1);


%%  State Two Ideal
s2s=s1;

T2s=XSteam('T_ps',P2,s2s);
h2s=XSteam('h_ps',P2,s2s);
u2s=XSteam('u_ps',P2,s2s);
v2s=XSteam('v_ps',P2,s2s);
x2s=XSteam('x_ps',P2,s2s);

%%  State Two Real
h2a=h1-0.85*(h1-h2s);

T2a=XSteam('T_ph',P2,h2a);
s2a=XSteam('s_ph',P2,h2a);
u2a=XSteam('u_ph',P2,h2a);
v2a=XSteam('v_ph',P2,h2a);
x2a=XSteam('x_ph',P2,h2a);

%% State Three Ideal

s3s=s2a;
T3s=XSteam('T_ps',P3,s3s);
h3s=XSteam('h_ps',P3,s3s);
u3s=XSteam('u_ps',P3,s3s);
v3s=XSteam('v_ps',P3,s3s);
x3s=XSteam('x_ps',P3,s3s);

%% State Three Real

h3a=h2a-0.85*(h2a-h3s);
T3a=XSteam('T_ph',P3,h3a);
u3a=XSteam('u_ph',P3,h3a);
v3a=XSteam('v_ph',P3,h3a);
x3a=XSteam('x_ph',P3,h3a);
s3a=XSteam('s_ph',P3,h3a);

%% State Four 
P4=P3;

T4=XSteam('Tsat_p',P4);
h4=XSteam('hL_p',P4);
u4=XSteam('uL_p',P4);
v4=XSteam('vL_p',P4);
s4=XSteam('sL_p',P4);

%% State Five Ideal
P5=P2;
s5s=s4;
T5s=XSteam('T_ps',P5,s5s);
h5s=XSteam('h_ps',P5,s5s);
u5s=XSteam('u_ps',P5,s5s);
v5s=XSteam('v_ps',P5,s5s);

%% State Five Real

h5a=h4+(h5s-h4)/E_P_1;


T5a=XSteam('T_ph',P5,h5a);
u5a=XSteam('u_ph',P5,h5a);
v5a=XSteam('v_ph',P5,h5a);
s5a=XSteam('s_ph',P5,h5a);

%% State Six
P6=P5;

T6=XSteam('Tsat_p',P6);
h6=XSteam('hL_p',P6);
u6=XSteam('uL_p',P6);
v6=XSteam('vL_p',P6);
s6=XSteam('sL_p',P6);

%% State Seven Ideal
P7=P1;
s7s=s6;

T7s=XSteam('T_ps',P7,s7s);
h7s=XSteam('h_ps',P7,s7s);
u7s=XSteam('u_ps',P7,s7s);
v7s=XSteam('v_ps',P7,s7s);


%% State Seven Real
h7a=h6+(h7s-h6)/E_P_2;

T7a=XSteam('T_ph',P7,h7a);
u7a=XSteam('u_ph',P7,h7a);
v7a=XSteam('v_ph',P7,h7a);
s7a=XSteam('s_ph',P7,h7a);

%% EFFICIENCY CALCULATON 

y=(h6-h5a)/(h2a-h5a); % The value of the mass going to the Open Feed Water from the Turbine

Qin=m_dot*(h1-h7a); % The Heat Energy coming from the Boiler

W_T=m_dot*((h1-h2a)+(1-y)*(h2a-h3a)); % Turbine Work

W_P=m_dot*((h7a-h6)+ (1-y)*(h5a-h4)); % Pump Work

W_Cycle = W_T-W_P; % Total Work of the Cycle

EF_Cycle=(W_Cycle)/Qin; % Efficiency of the Cycle



%% Exergy Analysis

To=300;  % The ambient Temperature in K
Po=2; % The ambient Pressure


%% Exergy analysis of Turbine

      % The First Turbine
Ex_Flow_Turbine_1= m_dot*((h2a-h1) - To*(s2a-s1));
Ex_Turbine_1_Destruction= m_dot*(To*(s2a-s1));

      % The Second Turbine
Ex_Flow_Turbine_2= m_dot*(1-y)*((h3a-h2a) - To*(s3a-s2a));
Ex_Turbine_2_Destruction= m_dot*(1-y)*(To*(s3a-s2a));



%% Exergy analysis of condenser

Ex_Flow_Condenser= m_dot*(1-y)*((h3a-h4) - To*(s3a-s4));
Ex_Condenser_Destruction=m_dot*(1-y)*(To*(s3a-s4));



%% Exergy analysis of pump
     
      % The First Turbone
Ex_Flow_Pump_1= m_dot*(1-y)*((h5a-h4) - To*(s5a-s4));

Ex_Pump_1_Destruction=m_dot*(1-y)*(To*(s5a-s4));

      % The First Turbone
Ex_Flow_Pump_2= m_dot*((h7a-h6) - To*(s7a-s6));

Ex_Pump_2_Destruction=m_dot*(To*(s7a-s6));


%% Exergy analysis of Open Feed Water

Ex_Flow_OFW=m_dot*(y*(h6-h2a)+(1-y)*(h6-h5a)-To*(y*(s6-s2a)+(1-y)*(s6-s5a)));

Ex_OFW_Destruction=m_dot*(To*(y*(s6-s2a)+(1-y)*(s6-s5a)));


%% Exergy analysis of Boiler
Ex_Flow_Boiler= m_dot*((h1-h7a) - To*(s1-s7a));
Ex_Boiler_Destruction=m_dot*(To*(s1-s7a));

%% Exergy Change of the system
EEE= (u7a-u1)+ Po*(v7a-v1)-To*(s7a-s1);



%%
T_lim=500; % Maximum Temperature limit for the pressure line.
T_d=T4-10; % Inital temperature value for the Pressure line.

n = linspace(T6,T_lim,300); % The Temperature values for the First Pressure line
m = linspace(T_d,100); % The Temperature values for the Second Pressure line
k= linspace(T_d,350);  % The Temperature values for the Third Pressure line


t=linspace (0,550,500);

 s1_concat=[];
for i = 1:length(n)
   s_Generated_1=XSteam('s_pT', P1,n(i));
    s1_concat=[s1_concat s_Generated_1];
end


s2_concat=[];
for i = 1:length(m)
   s_Generated_2=XSteam('s_pT', P4,m(i));
    s2_concat=[s2_concat s_Generated_2];
end


s3_concat=[];
for i = 1:length(k)
   s_Generated_3=XSteam('s_pT', P6,k(i));
    s3_concat=[s3_concat s_Generated_3];
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
plot(s1,T1, 'marker','x')
hold on
%Ploting state 2 points fro real environment
plot(s2a,T2a, 'marker','x')
%Ploting state 2 points for the isentropic environment 
plot(s2s, T2s, 'marker', 'x')

%Ploting state 3 points fro real environment
plot(s3a,T3a, 'marker', 'x')
%Ploting state 3 points fro real environment
plot(s3s,T3s, 'marker', 'x')

%Ploting state 4 points for the real environment 
plot(s4, T4, 'marker', 'x')

%Ploting state 5 points for the real environment 
plot(s5a, T5a, 'marker', 'x')
%Ploting state 5 points for the isentropic environment 
plot(s5s, T5s, 'marker', 'x')

%Ploting state 6 points 
plot(s6, T6, 'marker', 'x')

%Ploting state 7 points for the real environment 
plot(s7a, T7a, 'marker', 'x')
%Ploting state 7 points for the isentropic environment 
plot(s7s, T7s, 'marker', 'x')



%Ploting state 1 to 2
plot ([s1 s2s], [T1 T2s], 'marker','x','color', 'black','LineWidth',1)
plot ([s1 s2a], [T1 T2a], 'marker','x','color', 'black','LineWidth',2)
%Ploting state 2 to 3
plot([s2a s3s], [T2a T3s], 'marker','x','color', 'black','LineWidth',1)
plot ([s2a s3a], [T2a T3a], 'marker','x','color', 'black','LineWidth',2)

%Ploting state 3 to 4
plot ([s3a s4], [T3a T4], 'marker','x','color','black','LineWidth',3)


%Ploting state 4 to 5
plot ([s4 s5s], [T4 T5s], 'marker','x','color','black','LineWidth',1)
plot ([s4 s5a], [T4 T5a], 'marker','x','color','black','LineWidth',2)

%Ploting state 6 to 7
plot ([s6 s7s], [T6 T7s], 'marker','x','color','black','LineWidth',1)
plot ([s6 s7a], [T6 T7a], 'marker','x','color','black','LineWidth',2)

%Plot the ts of water in liquid
plot(sat_curve_h,t, 'marker','.','color','b')
%Plot the ts of water in Vapour

plot(sat_curve_t,t, 'marker','.','color','b')
plot(s1_concat,n, 'color', 'r','LineWidth',1)
plot(s2_concat,m, 'color', 'r','LineWidth',1)
plot(s3_concat,k, 'color', 'r','LineWidth',1)
text(s5a,T5a,'\rightarrow 5a')
text(s5s,T5s,'\leftarrow 5s')
text(s4,T4,'\rightarrow 4')
text(s6,T6,'\rightarrow 6')
text(s7a,T7a,'\rightarrow 7a')
text(s7s,T7s,'\leftarrow 7s')
title('Rankine Cycle T-S Diagram')
grid on
grid minor
xlabel('S')
ylabel('T')
hold off