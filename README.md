# FIR_filter
system Verilog FIR filter with modular number of delays (registers).

## TODO

[] System diagram (@Duncan)
[] GTK Wave plot with an explanation (@Duncan)
[] Describe the context for why this is useful (mention controls, signal processing, etc.) (@Riley)
[x] Matlab frequency domain and time domain impulse response (with description) (@Riley)
[] Paragraph overview of the code (@Duncan)
[] In-line code documentation (mostly, port descriptions) (@Riley)
[] How to use:
    [] What to expect regarding the asynchronous reset and divided clock (@Riley)
    [] What the makefile does (@Duncan)
    [] What the python script does (csv generation) (@Duncan)

# Context (riley)

FIR filters are useful in a number of domains. Primarily, we were interested in their use for controls and signal processing. In signal processing, they are used as a low pass filter that supresses undesirable noise. In controls, they are useful for proportional integral derivative (PID) control as a FIR filter can implement integrals and derivatives. Signal processing is necessary for audio filtering and noise cancellation, as well as cleaner signal outputs from electrical devices like sensors. Controls is necessary for modern day robotics.

system Verilog is an ideal route for implementing an FIR filter as controls with high level programming languages (C++, Arduino, etc.) take longer to run and cannot respond as quickly to changes in the system. system Verilog as a hardware language can respond quickly and could be run on an FPGA to implement effective robotics control in real time.

# Overview

"Duncan and I have changed our MVP to simulating a behavioral system Verilog tapped FIR filter using addition, multiplication, and registers (as delay z^-1 blocks). Our test bench will simulate a step response. We will create a gtkwave file showing the input and output after the filter to validate that this is functioning. We will also write a brief paragraph with a block diagram for how this would benefit a PI control loop.

The stretch goal would be putting our values into Matlab to see a frequency domain plot. A further stretch goal would be to implement the other control blocks in system Verilog to simulate a full PI control loop (subtractor for input, multiplication block). "


## System Diagram

## Code Overview

We validated our system Verilog FIR filter using the Matlab filter design tool. In the design tool we created an FIR filter and saved the co-efficients. 

![Matlab filter design tool](/readme_materials/filter_design_coeffs.PNG)

We then ran these co-efficients in system Verilog and output y_out values. Using the y_out values, we then plotted the impulse response and the frequency response of the filter in matlab and compared the graphs to the Matlab filter design tool graphs. We found that our results aligned with the expected behavior.

Matlab filter design tool graphs:
![Matlab filter design tool](/readme_materials/filter_designer_impulse_response.PNG)
![Matlab filter design tool](/readme_materials/filter_designer_freq_response.PNG)

Matlab plots of our results:
![Matlab filter design tool](/readme_materials/impulse_response_plot.png)
![Matlab filter design tool](/readme_materials/frequency_response_plot.png)


# Usage

## Running the testbench

## Examples
