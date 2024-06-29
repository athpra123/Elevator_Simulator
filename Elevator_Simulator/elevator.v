//elevator control algorithm.

module elevator(clk,rst,ra,rb,rc,rd,sled,floor);
input clk,rst;
input ra,rb,rc,rd;
//output [1:0] floor;
output reg [6:0] sled;
output reg [3:0] floor;
parameter A=0,B=1,C=2,D=3;
reg [1:0] state;
reg dir;
parameter UP=0,DO=1,STAY=2;
reg [25:0] temp;
reg srst;
reg sclk;

initial
begin
	temp<=0;
	srst<=0;
	
end

always@(posedge clk or posedge rst)
begin
	if(rst==1)
		srst<=1;
	else
	begin
		if(temp[25]==1)
		begin
			temp<=0;
		end
		sclk<=temp[25];			
		temp<=temp+1;
	end	
end

always@(posedge sclk or posedge rst)
begin
	if(rst) state <= A;
	else
	begin
		case(state)
		
		A: case(dir)
		STAY: case(1)
					default: state<=A;
				endcase
		UP: case(1)
			ra: state <= A;
			rb: state <= B;
			rc: state <= B;
			rd: state <= B;
			endcase
		endcase
		B: case(dir)
		STAY: case(1)
			default: state<=A;
		endcase
		UP: case(1)
					rb: state <= B;
					rc: state <= C;
					rd: state <= C;
					ra: state <= A;
				endcase
		DO: case(1)
					rb: state <= B;
					ra: state <= A;
					rc: state <= C;
					rd: state <= C;
				endcase
		endcase
		C: case(dir)
			STAY: case(1)
						default: state<=A;
					endcase
			UP: case(1)
					rc: state <= C;
					rd: state <= D;
					rb: state <= B;
					ra: state <= B;
				 endcase
			DO: case(1)
					rc: state <= C;
					rb: state <= B;
					ra: state <= B;
					rd: state <= D;
				 endcase
		endcase
		D: case(dir)
				STAY: case(1)
					default: state<=A;
				endcase
				DO: case(1)
						rd: state <= D;
						rc: state <= C;
						rb: state <= C;
						ra: state <= C;
				endcase
		endcase
		endcase
end
end


always@(posedge sclk or posedge rst)
begin
	if(rst) dir <= A;
	else
		begin
			case (state)
			
			A: case(1)
				ra: dir <= UP;
				rb: dir <= UP;
				rc: dir <= UP;
				rd: dir <= DO;
				endcase
			B: case (dir)
				UP: case(1)
					rb: dir <= UP;
					rc: dir <= UP;
					rd: dir <= DO;
					ra: dir <= UP;
					endcase
				DO: case(1)
					rb: dir <= DO;
					ra: dir <= UP;
					rc: dir <= UP;
					rd: dir <= DO;
					endcase
				endcase
			C: case (dir)
				UP: case(1)
					rc: dir <= UP;
					rd: dir <= DO;
					rb: dir <= DO;
					ra: dir <= UP;
					endcase
				DO: case(1)
					rc: dir <= DO;
					rb: dir <= DO;
					ra: dir <= UP;
					rd: dir <= DO;
					endcase
				endcase
			D: case(1)
				rd: dir <= DO;
				rc: dir <= DO;
				rb: dir <= DO;
				ra: dir <= UP;
				endcase
		endcase
		
		case (state)
			A: begin
				sled <= 7'b0000001;
				floor = 4'b0001;
				end
			B: begin
				sled <= 7'b1001111;
				floor = 4'b0010;
				end
			C: begin
				sled <= 7'b0010010;
				floor = 4'b0100;
				end
			D: begin
				sled <= 7'b0000110;
				floor = 4'b1000;
				end
	endcase
end
end
//assign floor = state;


endmodule