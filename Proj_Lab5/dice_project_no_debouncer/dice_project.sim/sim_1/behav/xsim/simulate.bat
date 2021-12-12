@echo off
REM ****************************************************************************
REM Vivado (TM) v2019.1 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Sat Dec 04 14:35:16 +0100 2021
REM SW Build 2552052 on Fri May 24 14:49:42 MDT 2019
REM
REM Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
echo "xsim dice_tb_behav -key {Behavioral:sim_1:Functional:dice_tb} -tclbatch dice_tb.tcl -view C:/Users/muresant18/OneDrive - FH JOANNEUM/Dokumente/timi/DE/Lab5/dice_project/dice_tb_behav.wcfg -log simulate.log"
call xsim  dice_tb_behav -key {Behavioral:sim_1:Functional:dice_tb} -tclbatch dice_tb.tcl -view C:/Users/muresant18/OneDrive - FH JOANNEUM/Dokumente/timi/DE/Lab5/dice_project/dice_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0