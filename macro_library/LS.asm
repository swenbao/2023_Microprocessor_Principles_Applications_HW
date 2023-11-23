; arithmetic / logical left shift
LS macro reg
    RLNCF reg
    BCF reg, 0
    endm