module Frequency_Meter (input wire clk, input wire signal, 
output wire [6:0]anodes, output wire [3:0] kathodes, output reg output_signal);

parameter N = 50000000;

reg[1:0] synchronization = 0;

reg [25:0] counter = 0;

reg [9:0] summ = 0;

reg [9:0] register = 0;

reg [25:0] generator = 0;

reg previous_signal = 0;

reg [9:0] result = 0;

wire enable;

always @(posedge clk)
begin 
	
	synchronization[0] <= signal;
	
	synchronization[1] <= synchronization[0];

end


always @(posedge clk)
begin

	generator <= generator + 1;
	
	if(generator == 2500000)
	begin
	
		generator <= 0;
		
		output_signal <= ~ output_signal;
	
	end
end


always @(posedge clk)
begin
	counter <= counter + 1;
	
	if(counter == N)
	begin
		
		result <= summ;
		
		counter <= 0;

		summ <= 0;
	
	end
	
	else
	
	if(synchronization[1] && ~previous_signal)
	begin
	
		summ <= summ + 1;		
		
		previous_signal <= 1;		
	
	end
	
	else
	
	if(~synchronization[1])
	begin
	
		previous_signal <=0;
	
	end	
	
end

wire [3:0] unused;

wire isPushed;

// test_input in(clk, signal, unused[0], isPushed, unused[1]);

Switcher switcher( clk, result, kathodes, anodes);

endmodule
