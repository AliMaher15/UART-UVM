// Class: state_transition_reset_test
//
// jump to the pre_reset_phase to hit specific FSM transitions
class state_transition_reset_test extends uart_tx_input_test;
    `uvm_component_utils(state_transition_reset_test)
 
    // field: hit_reset
    // Clear this after the reset event to ensure that it only happens once
    bit hit_reset = 1;
    enum bit [2:0] {
      IDLE, 
      Start_bit, 
      ser_data, 
      par_bit, 
      Stop_bit} states = IDLE;
 
    // field: reset_delay_ns
    // The amount of time, in ns, before applying reset during the main phase
    int unsigned reset_delay_ns;
 
    function new(string name="active_reset", uvm_component parent=null);
       super.new(name, parent);
    endfunction : new
 
    virtual task main_phase(uvm_phase phase);
       fork
          super.main_phase(phase);
       join_none
       
       // random time
       if(hit_reset) begin
          
          case(states)
            IDLE: begin
               states = Start_bit;
               Randomize_reset_delay_time: assert ( std::randomize(reset_delay_ns) with { reset_delay_ns inside {[200:400]}; } );
               jump_to_reset_phase(phase, reset_delay_ns);
            end
            Start_bit: begin
               states = ser_data;
               jump_to_reset_phase(phase, 30);
            end
            ser_data: begin
               states = par_bit;
               jump_to_reset_phase(phase, 50);
            end
            par_bit: begin
               states = Stop_bit;
               jump_to_reset_phase(phase, 118);
            end
            Stop_bit: begin
               hit_reset = 0;
               jump_to_reset_phase(phase, 120);
            end
          endcase
       end
    endtask : main_phase


    task jump_to_reset_phase(uvm_phase phase, input int reset_delay_ns);
      phase.raise_objection(this);
      #(reset_delay_ns * 1ns);
      phase.drop_objection(this);
      phase.get_objection().set_report_severity_id_override(UVM_WARNING, "OBJTN_CLEAR", UVM_INFO);
      `uvm_info("test", "Hitting Reset!!!", UVM_NONE)
      phase.jump(uvm_pre_reset_phase::get());
    endtask

 endclass : state_transition_reset_test