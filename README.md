# FIR Filter
A system Verilog FIR filter with parameterizable number of delays (registers).

## TODO

- [x] System diagram (@Duncan)
- [x] GTK Wave plot with an explanation (@Duncan)
- [x] Describe the context for why this is useful (mention controls, signal processing, etc.) (@Riley)
- [x] Matlab frequency domain and time domain impulse response (with description) (@Riley)
- [x] Paragraph overview of the code (@Duncan)
- [ ] In-line code documentation (mostly, port descriptions) (@Riley)
- [ ] How to use:
    - [ ] What to expect regarding the asynchronous reset and divided clock (@Riley)
    - [x] What the makefile does (@Duncan)
    - [x] What the python script does (csv generation) (@Duncan)

# Context (riley)

FIR filters are useful in a number of domains. Primarily, we were interested in their use for controls and signal processing. In signal processing, they are used as a low pass filter that suppresses undesirable noise. In controls, they are useful for proportional integral derivative (PID) control as a FIR filter can implement integrals and derivatives. Signal processing is necessary for audio filtering and noise cancellation, as well as cleaner signal outputs from electrical devices like sensors. Controls is necessary for modern day robotics.

system Verilog is an ideal route for implementing an FIR filter as controls with high level programming languages (C++, Arduino, etc.) take longer to run and cannot respond as quickly to changes in the system. system Verilog as a hardware language can respond quickly and could be run on an FPGA to implement effective robotics control in real time.

# Overview

Primary System Verilog files:
- [fir_n.sv](fir_n.sv)
- [tapped_delay_block.sv](tapped_delay_block.sv)

## FIR Filter Overview

An FIR filter is a filter whose frequency domain response can be described in the Z-plane as a polynomial expression of `z^-1` terms:

<img src="/readme_materials/fir_z_domain_eq.png" height="70rem" alt="fir z domain equation"/>

In the time domain, the above equates to:

<img src="/readme_materials/fir_time_domain_eq.png" height="70rem" alt="fir time domain equation"/>

The block diagram of the above takes the following form:

<img src="/readme_materials/fir_block.png" width="70%" alt="fir block diagram"/>

## System Design

### Modularity

To enable the number of delays to be parameterizable, we made the decision to design the FIR module such that it is composed of `tapped_delay_block` module instances that are created in a `generate` statement. The following diagram illustrates the functionality of the `tapped_delay_block` within the context of a FIR block diagram:

<img src="/readme_materials/tapped_delay_filter_block.png" width="50%" alt="tapped delay block illustration"/>

Notice that there are two outputs of the `tapped_delay_block` module, where one experiences a delay of z^-1 and the other is determined combinationally as a linear product of its inputs. When chained together, `n` `tapped_delay_block` modules create a `(n-1)`-th order FIR filter (i.e., one with a maximum delay of `z^{-{n-1}}`). A drawback of this approach is that it implies one unnecessary adder and register; however, the upside of enabling relatively simple generalization to filters of arbitrary orders is great.

### Schematic

The below schematic illustrates the `fir_n` module and its constituent `tapped_delay_block` module instances:

<img src="/readme_materials/fir_schematic.png" width="100%" alt="fir schematic"/>

Note that all coefficients, `N`-bit signal inputs, and `N`-bit signal outputs are interpreted as signed (two's complement) integers.

#### Resetting

The frequency of the `clk` implies the input signal's sampling frequency, and correspondingly, each register induces a time delay equivalent to the reciprocal of the `clk` frequency. Because it is the case in practical use cases that the system clock is far slower than the clk signal used for the filter, all flip-flips in the `fir_n` module (and its submodules) are asynchronously resettable (i.e., they are sensitive to the positive edge of both `clk` and `rst`).

#### Filter Coefficients

The `b` port of the `fir_n` module contains the filter's coefficients such that the `N` least significant bits correspond to the 0-th `tapped_delay_block` instance's input coefficient and the `N` most significant bits correspond to the n-th `tapped_delay_block` instance's input coefficient.

# Usage

The `Makefile` includes the `test_fir_n` recipe which invokes the testbench (see [test_fir_n.sv](test_fir_n.sv)). The testbench, as currently implemented, does the following:

- Asserts `rst` for two clock cycles and holds `ena` high for the duration of the whole simulation.
- Generates a 48 kHz `clk_d` signal to be used the `clk` port of the `fir_n` module. It is generated using a clock divider driven by the system 12 mHz clock.
- Asserts the filter coefficients according to what is hard-coded in the testbench.
- Stimulates the `x_in` signal of the `fir_n` module with an impulse of magnitude 1000, then lets the response play out. The number of delays used is hard-coded as a testbench module parameter.

Using the print task within the `fir_n` module, the filter's input and output signals are sent to `stdout` in a CSV format. As such, the `test_fir_n` recipe also invokes the [parse_output.py](parse_output.py) script which consumes these input and output signals and writes them to a `.csv` in the `results/` folder.

## GTKWave Example

Included in this repository is a [GTKWave configuration file](gtk.gtkw) that shows the following after running the testbench with `n=4` `tapped_delay_blocks`:

<img src="/readme_materials/gtkw.png" width="60%" alt="GTKWave screenshot"/>

The orange signals illustrate the `x_in` signals for the `fir_n` and `tapped_delay_block` modules. As can be seen, the asynchronously asserted input gets synchronized with `clk_d`, and the delays induced by the filter can be seen in the impulse appearing to travel from left to right as you look from top (the first `tapped_delay_block`) to bottom (the last `taped_delay_block`). Interpretation of the output can be found in the below "validation" section.

# Validation

We validated the `fir_n` module using a testbench and the Matlab filter design tool. In the design tool we created an FIR filter and saved the co-efficients. 

<img src="/readme_materials/filter_design_coeffs.PNG" width="60%" alt="Matlab filter design tool screenshot"/>

We then input these coefficients into the testbench and plotted the resulting impulse response and the frequency response of the filter in matlab. These plots, when compared the expected impulse and frequency response as indicated by the Matlab filter design tool graphs, validate the correctness of our implementation. Note that the magnitude of the test-bench's output differs from the expected output; this is due to our manual scaling and rounding of the coefficients and magnitude-1000 impulse stimulation to account for the fact that our setup expects signed integer signals and coefficients.

### Matlab filter design tool graphs (expected output)

<img src="/readme_materials/filter_designer_impulse_response.PNG" width="60%" alt="expected impulse response"/>
<img src="/readme_materials/filter_designer_freq_response.PNG" width="60%" alt="expected frequency response"/>

### Matlab plots of our results (testbench output)

<img src="/readme_materials/impulse_response_plot.png" width="60%" alt="simulated impulse response"/>
<img src="/readme_materials/frequency_response_plot.png" width="60%" alt="simulated frequency response"/>
