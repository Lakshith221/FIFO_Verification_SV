class monitor;

    transaction tr;
    mailbox #(bit [7:0]) mbx;
    bit [7:0] srx, rrx;
    virtual uart_if vif;

    function new(mailbox #(bit [7:0]) mbx);
        this.mbx = mbx;
    endfunction

    task run();
        forever begin
            @(posedge vif.uclktx);
            if (vif.newd && vif.rx) begin
                for(int i=0;i<8;i++) @(posedge vif.uclktx) srx[i]=vif.tx;
                $display("[MON]: DATA SEND on UART TX %0d", srx);
                mbx.put(srx);
            end else if (!vif.newd && !vif.rx) begin
                wait(vif.donerx);
                rrx = vif.doutrx;
                $display("[MON]: DATA RCVD RX %0d", rrx);
                mbx.put(rrx);
            end
        end
    endtask

endclass
