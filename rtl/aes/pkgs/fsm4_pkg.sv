package fsm4_pkg;
    //declare your enum here, enum name should be "state_e"
    typedef enum logic[1:0] { IDLE = 0, INITIAL_ROUND =1, MID_ROUND =2, LAST_ROUND=3  } state_e;
endpackage
