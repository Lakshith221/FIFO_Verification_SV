class driver;

    virtual uart_if vif;
    transaction tr;
    mailbox #(transaction) mbx;
    mailbox #(bit [7:0]) mbxds;
    event drvnext;
    bit [7:0] datarx;

    function new(mailbox #(bit [7:0]) mbxds, mailbox #(transaction) mbx);
        this.mbx = mbx;
        this.mbxds = mbxds;
    endfunction

    task reset();
        vif.rst <= 1'b1;
        vif.dintx <= 0;
        vif.newd <= 0;
        vif.rx <= 1'b1;
        repeat(5) @(posedge vif.uclktx);
        vif.rst <= 1'b0;
        @(posedge vif.uclktx);
        $display("[DRV] RESET DONE\n----------------------------------------");
    endtask

    task run();
        forever begin
            mbx.get(tr);
            if(tr.oper == 1'b0) begin // write
                @(posedge vif.uclktx);
                vif.newd <= 1'b1;
                vif.dintx <= tr.dintx;
                @(posedge vif.uclktx);
                vif.newd <= 1'b0;
                mbxds.put(tr.dintx);
                $display("[DRV]: Data Sent : %0d", tr.dintx);
                wait(vif.donetx == 1'b1);
                ->drvnext;
            end else begin // read
                @(posedge vif.uclkrx);
                vif.rx <= 1'b0;
                @(posedge vif.uclkrx);
                for(int i=0; i<8; i++) begin
                    @(posedge vif.uclkrx);
                    datarx[i] = $urandom;
                end
                mbxds.put(datarx);
                $display("[DRV]: Data RCVD : %0d", datarx);
                wait(vif.donerx == 1'b1);
                vif.rx <= 1'b1;
                ->drvnext;
            end
        end
    endtask

endclass
