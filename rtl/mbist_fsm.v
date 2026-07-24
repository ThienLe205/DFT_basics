module mbist_fsm (
    input clk,
    input rst_n, 
    input start_test,
    
    output reg we_out,
    output wire [3:0] addr_out,
    output reg [7:0] data_out,
    input [7:0] data_in,
    
    output reg done_flag,
    output reg err_flag
);

    reg [2:0] state; // 0: idle, 1: write, 2: read_comp, 3: done
    reg [3:0] cnt;
    
    wire [7:0] pat = 8'hAA; 

    // noi truc tiep adr ra ngoai
    assign addr_out = cnt;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= 0;
            cnt <= 0;
            we_out <= 0;
            done_flag <= 0;
            err_flag <= 0;
            // data_out <= 8'd0; 
        end 
        else begin
            case(state)
                0: begin 
                    done_flag <= 0;
                    err_flag <= 0;
                    cnt <= 0;
                    we_out <= 0;
                    if(start_test) state <= 1; // vao trang thai ghi
                end
                
                1: begin 
                    we_out <= 1;
                    data_out <= pat;
                    
                    if(cnt == 15) begin
                        state <= 2;
                        cnt <= 0;
                        we_out <= 0; 
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                
                2: begin 
                    we_out <= 0;
                    
                    // check error data
                    if(data_in != pat) begin
                        err_flag <= 1;
                        // $display("Error at %d", cnt);
                    end

                    if(cnt == 15) begin
                        state <= 3;
                        cnt <= 0;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                
                3: begin // done
                    done_flag <= 1;
                    if(!start_test) state <= 0;
                end
                
                default: state <= 0;
            endcase
        end
    end

endmodule