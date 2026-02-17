class environment;

    generator gen;
    driver drv;
    monitor mon;
    scoreboard sco;
    mailbox #(transaction) mbxgd;
    mailbox #(bit [7:0]) mbxds, mbxms;
    event nextgd, nextgs;
    virtual uart_if vif;

    function new(virtual uart_if vif);
        mbxgd = new(); mbxds = new(); mbxms = new();
        gen = new(mbxgd);
        drv = new(mbxds, mbxgd);
        mon = new(mbxms);
        sco = new(mbxds, mbxms);
        this.vif = vif;
        drv.vif = vif;
        mon.vif = vif;
        gen.drvnext = drv.drvnext = nextgd;
        gen.sconext = sco.sconext = nextgs;
    endfunction

    task pre_test(); drv.reset(); endtask
    task test(); fork gen.run(); drv.run(); mon.run(); sco.run(); join_any endtask
    task post_test(); wait(gen.done.triggered); $finish(); endtask
    task run(); pre_test(); test(); post_test(); endtask

endclass
