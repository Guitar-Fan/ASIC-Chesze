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
 wire net4;
 wire net1;
 wire net2;
 wire net3;

 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_0_Left_17 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_0_Right_0 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_10_Left_27 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_10_Right_10 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_11_Left_28 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_11_Right_11 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_12_Left_29 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_12_Right_12 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_13_Left_30 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_13_Right_13 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_14_Left_31 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_14_Right_14 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_15_Left_32 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_15_Right_15 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_16_Left_33 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_16_Right_16 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_1_Left_18 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_1_Right_1 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_2_Left_19 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_2_Right_2 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_3_Left_20 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_3_Right_3 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_4_Left_21 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_4_Right_4 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_5_Left_22 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_5_Right_5 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_6_Left_23 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_6_Right_6 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_7_Left_24 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_7_Right_7 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_8_Left_25 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_8_Right_8 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_9_Left_26 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_9_Right_9 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_34 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_35 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_36 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_37 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_38 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_39 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_40 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_10_72 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_10_73 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_10_74 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_10_75 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_11_76 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_11_77 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_11_78 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_12_79 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_12_80 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_12_81 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_12_82 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_13_83 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_13_84 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_13_85 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_14_86 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_14_87 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_14_88 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_14_89 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_15_90 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_15_91 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_15_92 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_16_93 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_16_94 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_16_95 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_16_96 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_16_97 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_16_98 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_16_99 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_1_41 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_1_42 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_1_43 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_2_44 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_2_45 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_2_46 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_2_47 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_3_48 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_3_49 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_3_50 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_4_51 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_4_52 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_4_53 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_4_54 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_5_55 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_5_56 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_5_57 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_6_58 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_6_59 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_6_60 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_6_61 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_7_62 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_7_63 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_7_64 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_8_65 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_8_66 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_8_67 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_8_68 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_9_69 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_9_70 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_9_71 ();
 gf180mcu_fd_sc_mcu7t5v0__nor2_1 _2_ (.A1(net1),
    .A2(net3),
    .ZN(_0_));
 gf180mcu_fd_sc_mcu7t5v0__aoi21_1 _3_ (.A1(net1),
    .A2(net3),
    .B(net2),
    .ZN(_1_));
 gf180mcu_fd_sc_mcu7t5v0__nor2_1 _4_ (.A1(_0_),
    .A2(_1_),
    .ZN(net4));
 gf180mcu_fd_sc_mcu7t5v0__dlyb_1 input1 (.I(vote_a),
    .Z(net1));
 gf180mcu_fd_sc_mcu7t5v0__dlyb_1 input2 (.I(vote_b),
    .Z(net2));
 gf180mcu_fd_sc_mcu7t5v0__dlyb_1 input3 (.I(vote_c),
    .Z(net3));
 gf180mcu_fd_sc_mcu7t5v0__dlya_1 output4 (.I(net4),
    .Z(majority));
endmodule
