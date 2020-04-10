# SPLA Software

Simple notes on the design of the host-side software that

* One CLI tool, `spla`, with sub-commands.
* By default, uses the SPLA device identified by matching VID/PID/Serial.
  * Can use VID/PID from FTDI for now.
* Commands try to verify which FPGA image is on the board, and repogram if necessary.

* Category: Low-level commands
  * `show_ftdi`: Show all connected FTDI devices, VID/PID/Serial.
  * `bringup_ftdi_set_serial`: Set serial number of the device explicitly.
  * `bringup_ftdi_led`: Toggles the GPIO with an LED on it.
  * `bringup_fpga_ctl`: Toggle one of the FPGA image programming pins directly.
  * `bringup_fpga_spi`: Run a raw SPI transaction during programming.
  * `bringup_fpga`: Program the FPGA image that toggles just D4/D6.
  * `bringup_boundary_scan`: Program the FPGA image that runs boundary scan.
  * `bringup_field_timing`: Program the FPGA image that enables the PPUs and measures HBLANK / VBLANK timing.
  * `fpga_program`: Program the FPGA with a given image.
  * `fpga_version`: Show FPGA version and format registers.
  * `read`: Read a single register value.
  * `write`: Write a single register value.
  * `xin_stop`: Stop XIN clock.
  * `xin_start`: Start XIN clock.
  * `xin_run_to`: Run XIN to a specific cycle, or HBLANK or VBLANK.
  * `xin_step`: Clock XIN an exact number of times.
  * `xin_read`: Show XIN counter register.
  * `read_pin`: Read one or more individual pins.
  * `write_pin`: Write one or more individual pins.
  * `write_vram`: Write data to the VRAM chips.
  * `read_vram`: Write data to the VRAM chips.

* Category: Normal commands
  * `diagnostic`: Run diagnostic to check that things work as expected.
  * `bbus_scan`: Scan the B-bus and output results.  Intended for register source tracing.
  * `run`: Run one or more JSON test vectors, producing output files.

* Category: Data manipulation (doesn't use the board)
  * `serial`: Show (pre-compiled) hardware configuration of this board serial.
  * `vector_check`: Check formatting of input test vector JSON.
  * `registers`: Show built-in register table.
  * `pintable`: Show built-in pin index table.
  * `output_to_image`: Convert a test vector output to a PNG(?) image.
  * `output_to_vcd`: Convert a test vector output to a VCD signal file.
