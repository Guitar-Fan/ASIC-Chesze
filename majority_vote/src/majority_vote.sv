module majority_vote (
    input  logic vote_a,
    input  logic vote_b,
    input  logic vote_c,
    output logic majority
);
    assign majority = (vote_a & vote_b) |
                      (vote_a & vote_c) |
                      (vote_b & vote_c);
endmodule