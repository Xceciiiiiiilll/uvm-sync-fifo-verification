# UVM Synchronous FIFO Verification
![content _centered](https://github.com/user-attachments/assets/b82fbde3-57db-42ea-ac36-25c75682d5a5)

UVM testbench for a 16-deep synchronous FIFO (8-bit data width).
![BLOCK DIAGRAM](images/fifo_test1.png)

### Coverpoints

- `wr_en` 
- `rd_en`    
- `full`  
- `empty`
- `cross wr_en,full`
- `cross rd_en,empty`

    
Functional coverage: 100%
![coverage](images/fifo_coverage.png)


## Structure
- `rtl/`       : DUT (sync_fifo.sv)
- `tb/`        : UVM components (interface, package, top, tests)
- `sim/`       : Scripts/Makefile for running simulations

## Status
- [X] DUT complete
- [X] Basic UVM env
- [X] Coverage & scoreboard

Tools: Questa/EDA Playground
