
clear all
clc
close all

tsteps = [0:0.001:0.3];
[r,nu]=OrbitProp(tsteps,20000,0.5,0,201,156,0);
polarplot(nu,r,'b.')