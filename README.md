# TDA & tSNE

Bottleneck distance tSNE tests on MNIST data


# # PARAMETERS

diagram dimensions
	--DIMS | -D		A	B

tSNE dimension
	--DIM | -d		DIM

total number of samples (max 60K)
	--N | -n		N

diagrams per digit (class)
	--K | -k		K


# # TESTS

run all pairwise bottleneck distance tSNE tests on MNIST data
	--run-all | -a

K (N/K)-point A-D dimensional persistence diagrams
	--run-raw | -R
		per raw digit (class)
	--run-k | -K
		per tSNE digit (class)
	--run-one | -O
		per digit (class) from N-point tSNE


# # OPTIONS

show plot
	--ion
save plot and data
	--save | -S

save plot, data, and exit
	--test | -T
