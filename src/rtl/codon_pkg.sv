package codon_pkg;
    
    typedef enum logic [2:0] {
        IDLE,
        SEEK_START,
        OUTPUT,
        STOP
    } states_e;
    
    typedef struct packed {
        logic start, stop;
    } codon_signals_t;
    
endpackage