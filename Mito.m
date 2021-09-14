function C_mito=Mito(C,K_mito,B_mito)

C_mito=K_mito.*max(C-B_mito,0);


end
