module uart_tst(
	input clk,reset_n,
	input btn_0,btn_1,btn_2, btn_3,
	input rx,
	output tx,
	output[7:0] sseg,
	output[3:0] sel
 );
	 wire btn_2_tick, btn_3_tick;
	 wire[7:0] wr_data,rd_data;
	 wire rx_empty,tx_empty; 
	 uart_top m0
	 (
		.clk(clk),
		.reset_n(reset_n),
		.btn_0(btn_0),
		.btn_1(btn_1), //btn0=choose_key , btn1=enter_key 
		.rx(rx), 
		.rd_uart(btn_2_tick),
		.wr_uart(btn_3_tick),
		.wr_data(wr_data),
		.rd_data(rd_data),
		.tx(tx),
		.rx_empty(rx_empty),
		
		.tx_empty(tx_empty),
		.sseg(sseg),
		.sel(sel)
    );
	 
	 db_fsm m1
	(
		.clk(clk),
		.reset_n(reset_n),
		.sw(!btn_2),
		.db_level(),
		.db_tick(btn_2_tick)
    );
	 db_fsm m2
	(
		.clk(clk),
		.reset_n(reset_n),
		.sw(!btn_3),
		.db_level(),
		.db_tick(btn_3_tick)
    );	 
	 assign wr_data=rd_data; //just add 1 to the value received then transmit it back
	 
endmodule