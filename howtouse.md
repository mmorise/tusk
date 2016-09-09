# How to use TUSK

## 0. Preparation
The test script uses Dio() in WORLD.
Please download WORLD (MATLAB version) from the following.
http://ml.cs.yamanashi.ac.jp/world/english/index.html

## 1. usage

Since the file "tusk_example.m" is the test script of TUSK, please see it.
The file "commandlist.txt" is requied to set the conditions in
F0 estimators (The number of estimators and options in each estimator).

The format of commandlist.txt is follows:

```
2 				            : Number of estimators for evaluation.

DIO 				          : Name used for plot_figure.m.
op.frame_period = 1; 	: Options to fulfill the conditions for TUSK.
op.target_fs = fs; 		: Sampling frequency (48 kHz).
op.f0_floor = 40; 		: Floor used for searching F0.
op.f0_ceil = 1000; 		: Ceil used for searching F0.
r = Dio(x, fs, op); 	: F0 estimation on the basis of the conditions.
f0 = r.f0; 			      : Variable "f0" is used for evaluation.
                      : Blank line is used to switch the estimator.
DIO+StoneMask
f0 = StoneMask(x, fs, r.temporal_positions, r.f0);
```
Note: Since the variables are not deleted, we can reuse them.
Variables "x" and "fs" are defined in advance as input waveform and sampling frequency.
You must not change them.

## 3. For F0 estimator developed on C (.exe in Windows OS)
MATLAB has the function "system()" in Windows OS, and you can call F0 estimators developed on other languages such as C.
This is an example of commandlist.txt with an F0 estimator (f0_estimation.exe in Windows OS).
The format of this estimator is 

```
> f0_estimation.exe input_name output_name
```

Conditions are set appropriately (you can also set them by arguments when calling it).
The file "output_name" consists of a text that is F0 sequence (1 ms frame shift).
Binary file can be used, but you must implement the loader.

```
TEST
x = 0.8 * x / max(abs(x)); % Amplitude normalization
% File output.
filename = sprintf('test%d.wav', option);
audiowrite(filename, x, fs, 'BitsPerSample', 24);
% F0 estimation (please modify following area)
command = sprintf('f0_estimation.exe %s output%d.txt', filename, option);
system(command);
filename = sprintf('output%d.txt', option);
f0 = load(filename);
% Delete temporaly files
command = sprintf('del output%d.txt', option);
system(command);
command = sprintf('del test%d.wav', option);
system(command);
```
Note: TUSK has a hidden variable "option". This is used for parallel processing, and you must not modify.
