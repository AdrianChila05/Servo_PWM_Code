`timescale 1ns / 1ps

module Servo_PWM (
    input clk,
    input open,
    input close,
    output reg pwm_out
);

// The PWM for the servo operates differently because its a 360% motor
// Pulse width = 1.5, 1.0-1.4 rotates counterclockwise, 1.6-2.0 rotates clockwise (longer distance from 1.5 means faster speed)
// Width of 2 is around 60 rpm, meaning it will take 1 seconds to rotate 360% degrees one time

reg [31:0] counter;
reg [31:0] PWMcounter;
reg [1:0] step;

 // Define the states for the sequence
localparam STEP_2MS = 2'b00;
localparam STEP_1MS = 2'b01;
localparam DONE = 2'b10;

// Parameters for 100 MHz clock
parameter CLK_FREQ = 100000000; // 100 MHz
parameter PWM_PERIOD = 2000000; // 20 ms period (50 Hz)
parameter PWM_PULSE_1MS = 100000; // 1 ms pulse width
parameter PWM_PULSE_2MS = 200000; // 2 ms pulse width


always @(posedge clk) begin
    
    if (close) begin
        if (PWMcounter < PWM_PULSE_2MS) begin
            pwm_out <= 0; // Generate 2 ms pulse
            PWMcounter <= PWMcounter + 1;
        end else if (PWMcounter < PWM_PERIOD) begin
             pwm_out <= 1; // Remain low for the rest of the period
             PWMcounter <= PWMcounter + 1;
        end else begin
            PWMcounter <= 0; // Reset counter for the next period
        end
    end

    else if (open) begin
        if (PWMcounter < PWM_PULSE_1MS) begin
            pwm_out <= 0; // Generate 1 ms pulse
            PWMcounter <= PWMcounter + 1;
        end else if (PWMcounter < PWM_PERIOD) begin
             pwm_out <= 1; // Remain low for the rest of the period
             PWMcounter <= PWMcounter + 1;
        end else begin
            PWMcounter <= 0; // Reset counter for the next period
        end
    end else begin
        pwm_out <= 0;
        PWMcounter <= 0;
    end

    
end

endmodule
