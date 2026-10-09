module majority_vote (majority,
    vote_a,
    vote_b,
    vote_c);
 output majority;
 input vote_a;
 input vote_b;
 input vote_c;

 wire _0_;
 wire _1_;
 wire VDD;
 wire VSS;

 gf180mcu_fd_sc_mcu7t5v0__nor2_1 _2_ (.A1(vote_a),
    .A2(vote_c),
    .ZN(_0_),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__aoi21_1 _3_ (.A1(vote_a),
    .A2(vote_c),
    .B(vote_b),
    .ZN(_1_),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__nor2_1 _4_ (.A1(_0_),
    .A2(_1_),
    .ZN(majority),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
endmodule
