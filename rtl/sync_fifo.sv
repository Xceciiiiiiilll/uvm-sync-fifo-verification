module sync_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic             wr_en,
    input  logic [WIDTH-1:0] wr_data,
    input  logic             rd_en,
    output logic [WIDTH-1:0] rd_data,
    output logic             full,
    output logic             empty
);

    logic [WIDTH-1:0] mem [0:DEPTH-1];
    logic [$clog2(DEPTH):0] wr_ptr, rd_ptr;  // +1 bit for full/empty distinction

    // Write logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) wr_ptr <= 0;
        else if (wr_en && !full) begin
            mem[wr_ptr[$clog2(DEPTH)-1:0]] <= wr_data;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Read logic (similar for rd_ptr)
    always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) rd_ptr <= 0;
      else if (rd_en && !empty) begin
        rd_data <= mem[rd_ptr[$clog2(DEPTH)-1:0]];
            rd_ptr <= rd_ptr + 1;
        end
    end
  
    // Full/empty logic
    assign full  = (wr_ptr[$clog2(DEPTH):0] == {~rd_ptr[$clog2(DEPTH)], rd_ptr[$clog2(DEPTH)-1:0]});
    assign empty = (wr_ptr == rd_ptr);

    // rd_data assignment, etc.

endmodule