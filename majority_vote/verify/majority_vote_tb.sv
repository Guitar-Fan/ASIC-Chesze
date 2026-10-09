module majority_vote_tb;
    logic vote_a;
    logic vote_b;
    logic vote_c;
    logic majority;
    logic expected;
    integer test_count;

    majority_vote dut (
        .vote_a(vote_a),
        .vote_b(vote_b),
        .vote_c(vote_c),
        .majority(majority)
    );

    initial begin
        $dumpfile("majority_vote.vcd");
        $dumpvars(0, majority_vote_tb);
        test_count = 0;

        for (integer votes = 0; votes < 8; votes = votes + 1) begin
            {vote_a, vote_b, vote_c} = votes[2:0];
            expected = ((votes[2] + votes[1] + votes[0]) >= 2);
            #1;
            test_count = test_count + 1;
            if (majority !== expected) begin
                $error("votes=%03b: expected majority=%b, got %b",
                       votes[2:0], expected, majority);
            end
        end

        $display("Passed %0d majority-vote tests", test_count);
        $finish;
    end
endmodule