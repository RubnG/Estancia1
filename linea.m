clear all; close all; clc;  %Declaraciones preeliminares
Ar1 = ['A3.nc'];                     %Nombre del Archivo
Var1 = 'U';                      %Variable a visualizar
Var2 = 'T'; 
Var3 = 'W';

%VARIABLES DEFINIDAS POR LAS DIMENCIONES DES LAS VARIABLES 

time = 43;                       %Horas totales 
dx = 20;                         %Grosor de la malla//////////
puntosx = 2001;                  %Tamaño horizontal de malla
puntosz = 99;                    %Tamaño Vertical de malla
gravedad = 1.352;

%--------------------------------------------
%eje x
dis = (puntosx-1) * dx / 2;      %Limite horizontal PARA CENTRAR
ejex1 = ((-dis):dx:(dis)) / 1000; %En metros ESCALA EL EJE EN 2000 PUNTOS DE LA VARIABLE 
clear dis
ejex2 = ejex1;
ejex1(length(ejex1)) = [];%PENDIENTE
timebar = 1:1:time;%barra "vector" de tiempo de un en uno en a 43


%DEFINE NIVELES EN Y
%Niveles verticales geométricos a partir del geopotencial:
PH= squeeze(ncread("A3.nc",'PH'));%squeeze para pasar de 2000x1x100x43 a 2000x100x43
PHB= squeeze(ncread("A3.nc",'PHB'));
gz = PHB + PH;
clear PHB PH

gz2d = mean(gz, 3, "omitmissing");%el promedio quitandi la dimension tiempo
ejez2 = mean(gz2d) ./ (gravedad);%eje z2 con 99 puntos
for i = 1:1:puntosz
    ejez(i) = (ejez2(i) + ejez2(i+1)) / 2;%eje z con 100 puntos
end
clear gz2d gz
%%%%%%%%%%%%%%%%%%%%%   FLUJOS MEDIOS Y FLUCTUACIONES %%%%%%%%%%%%%%
    
% Leemos la variable a visualizar
un = squeeze(ncread(Ar1, Var1));%'U'
t = squeeze(ncread(Ar1, Var2)) + 100;%'T'

for i = 1:1:puntosx-1   
    u(i,:,:) = (un(i,:,:)+un(i+1,:,:)) / 2;
end


%=======================================================



sheet=14;

figure;
contourf(ejex1, ejez, t(:,:,sheet)', 500, 'EdgeColor', 'none');  
% Magnitud de t en el tiiempo 24(tiempo elegido por el usuario) y transpuesta 
colormap(turbo), colorbar;
c = colorbar;

mincolor= min(mean(t(:,:,sheet)));%valor maximo de t
maxcolor= max(mean(t(:,:,sheet)));%valor maximo de t
clim([mincolor,maxcolor])%forzar color del maximo y minimo segun l colorbar de la variable en contourf
ylabel('Height (m)');
xlabel('Distance (Km)');

figure
tp = tiledlayout(1,1);
ay1 = axes(tp);
plot(ay1,t(:,:,sheet)',ejez,'b','LineWidth',2);
    ay1.XColor = 'black';
    ay1.YColor = 'b';
    ylabel('Altura')
    xlabel('Temperatura')
  % xlim([mincolor maxcolor]);
    % ylim([0.08 0.16])
    % ylim([-7 1.15]);
legend({'Parametrized SHF'},"AutoUpdate","on",'Location','northeast');
