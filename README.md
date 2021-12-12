# FIR_filter
system Verilog FIR filter with modular number of delays

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

# Context

# Overview

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
