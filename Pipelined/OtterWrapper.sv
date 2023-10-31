`timescale 1ns/1ps

module OtterWrapper(
    output [31:0] IOBUS_ADDR,
    output [31:0] IOBUS_OUT,
    output IOBUS_WR
);
    reg CLK = 0;
    reg RST, INTR;

    initial forever #20 CLK = !CLK;

    initial begin
        INTR = 0;
        RST = 1;
        #600
        RST = 0;
    end

    Otter CPU(
        .IOBUS_IN(32'd0),
        .RST(RST),
        .INTR(INTR),
        .CLK(CLK),
        .IOBUS_OUT(IOBUS_OUT),
        .IOBUS_ADDR(IOBUS_ADDR),
        .IOBUS_WR(IOBUS_WR)
    );

endmodule