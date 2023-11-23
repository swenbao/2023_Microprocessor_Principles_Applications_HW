; 𝐚𝐫𝐢𝐭𝐡𝐦𝐞𝐭𝐢𝐜 𝐫𝐢𝐠𝐡𝐭 𝐬𝐡𝐢𝐟𝐭
ARITHRS macro reg
    RRNCF reg ;
    BCF reg, 7
	BTFSC reg, 6 ;
	    BSF reg, 7;
    endm