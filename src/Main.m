%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: Main
% File: Main.m
% Description: Entry point for RasterToVector project.
% Created: June 20, 2011
% Authors: Scott Stevenson & Donovan Benoit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Main()
%%% CONSTANTS %%%
global DISPLAY_PRINTS;
DISPLAY_PRINTS = 1;
global MODE;
MODE = 'photo';
global SHOW_INTERMEDIATES;
SHOW_INTERMEDIATES = 1;
%%%%%%%%%%%%%%%%%

img = imread('ColoredStarsBlackBGDigital.png');
ToPolys(img,4,100);