
package tb_4_states;

typedef enum logic [1:0]{
    RESET,
    R_W,
    Rand_R_W,
    Reset
  } tb_states;

tb_states tb_state;
parameter int DATA_WIDTH = 4;

//Use semaphores or events to avoid race conditions. Look at this later

logic w_reset_done = 0;
logic w_fill_done = 0;
logic r_read_done = 0;
logic w_reset = 1;
logic r_rand = 0;
logic w_rand = 0;
logic w_reset_tst_done = 0;
logic r_reset_tst_done = 0;
logic test_done = 0;

endpackage