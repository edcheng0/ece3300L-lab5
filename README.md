# ece3300L-lab5 : Seven-Segment Display Driver
## Files
### Design
- [`src/timer_parameter.v`](verilog/design/timer_parameter.v) – starter: timer with parameter FINAL_VALUE
- [`src/timer_input.v`](verilog/design/timer_input.v) – starter: timer with input FINAL_VALUE
- [`src/udl_counter.v`](verilog/design/udl_counter.v) – starter: up/down/load counter
- [`src/decoder_generic.v`](verilog/design/decoder_generic.v) – starter: parameterized decoder
- [`src/hex2sseg.v`](verilog/design/hex2sseg.v) – starter: hex to seven-segment converter
- [`src/button.v`](verilog/design/button.v) – starter: synchronizer and rising-edge detector
- [`src/first_sseg_driver.v`](verilog/design/first_sseg_driver.v) – Lab 3: rudimentary seven-segment driver
- [`src/first_sseg_driver_test.v`](verilog/design/first_sseg_driver_test.v) – Part 1 top module
- [`src/mux_8x1_6bit.v`](verilog/design/mux_8x1_6bit.v) – Part 2: 8x1 6-bit mux
- [`src/sseg_driver.v`](verilog/design/sseg_driver.v) – Part 2 driver module
- [`src/sseg_driver_demo.v`](verilog/design/sseg_driver_demo.v) – Part 2 board demo top module
- [`src/counter_application.v`](verilog/design/counter_application.v) – Part 3 top module
- [`src/bin2bcd.v`](verilog/design/bin2bcd.v) – Lab 2: binary to BCD converter
### Sim
- [`tb/tb_first_sseg_driver_test.v`](verilog/sim/tb_first_sseg_driver_test.v) – Part 1 testbench
- [`tb/tb_sseg_driver.v`](verilog/sim/tb_sseg_driver.v) – Part 2 testbench
- [`tb/tb_counter_application.v`](verilog/sim/tb_counter_application.v) – Part 3 testbench
- [`tb/tb_bin2bcd.v`](verilog/sim/tb_bin2bcd.v) – Lab 2 binary to BCD testbench
### Constraints
- [`constraints/part1_first_sseg_driver_test.xdc`](verilog/constraints/part1_first_sseg_driver_test.xdc) – Part 1 board constraints, Nexys A7-100T
- [`constraints/part2_sseg_driver_demo.xdc`](verilog/constraints/part2_sseg_driver_demo.xdc) – Part 2 board constraints, Nexys A7-100T
- [`constraints/part3_counter_application.xdc`](verilog/constraints/part3_counter_application.xdc) – Part 3 board constraints, Nexys A7-100T
## Part 1: Timer-Controlled Counter
Simulation waveform:
![Part 1 waveform](screenshots/part1_waveform.png)
Schematic:
![Part 1 schematic](screenshots/part1_schematic.png)
## Part 2: Complete Seven-Segment Driver
Simulation waveform:
![Part 2 waveform](screenshots/part2_waveform.png)
Schematic:
![Part 2 schematic](screenshots/part2_schematic.png)
## Part 3: Up/Down/Load Counter on Seven-Segment Display
Simulation waveform:
![Part 3 waveform](screenshots/part3_waveform.png)
Block diagram:
![Part 3 block diagram](screenshots/part3_blockdiagram.png)
## Demo Videos
- Part 1: [`videos/part1_demo.mp4`](videos/part1_demo.mp4)
- Part 2: [`videos/part2_demo.mp4`](videos/part2_demo.mp4)
- Part 3: [`videos/part3_demo.mp4`](videos/part3_demo.mp4)
