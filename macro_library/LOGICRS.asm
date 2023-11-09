; logical right shift
LOGICRS macro reg
    RRNCF reg ;
    BCF reg, 7
    endm