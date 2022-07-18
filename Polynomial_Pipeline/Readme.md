# Pipleline Approach for High Speed Design
Pipelining is one of most common and powerful approach for designing high speed ASIC/FPGA logic.

Here, I design a cubic equation y = x^3 + k, where x is the input and k is a constant value.
If you synthesize and run the testbench, you will notice three cycle initial latency and after
we have achieved steady state i.e. pipeline is full, the result is generated every clock cycle.
Thereby achieving increased single cycle throughput.

Here's a quick way to run the design using EDAPlayground: https://www.edaplayground.com/x/RNXY
