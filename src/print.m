%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: print
% File: print.m
% Description: Prints a string to the MATLAB console if printing is
% enabled.
% Created: June 20, 2011
% Authors: Scott Stevenson & Donovan Benoit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function print(string)
% string    string to display if DISPLAY_PRINTS is enabled
    global DISPLAY_PRINTS;
    
    if DISPLAY_PRINTS == 1 
        disp(string);
    end