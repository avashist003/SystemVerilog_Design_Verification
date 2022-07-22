# Formal Verification of a Counter [SystemVerilog]
The design is a counter that counts down from a start value to zero. The start value is fixed and is set to 4'ha.
The counter follows a ready/valid protocol at the input interface.

The detailed description for formal verification of the counter is shown in my blog: https://www.autonomousvision.io/blog/formal-verification-symbiyosys

I use Symbiyosys formal tool to implement the formal property verification environment.

SVA based properties for counter:
- Reset value checks: After reset, the outputs should default to reset values.
- Ready/Valid interface: We will follow the ready/valid specification for the input interface.
- DUT Functionality: When the counter accepts a valid input request it should start with the correct start value and decrement until it goes to 0.
Should not accept any new incoming requests when it is busy.
- Data Integrity: For this design, we don't have data integrity verification
