module RTDA

using RCall, ProgressMeter

export filter_bcodes,
    landscape!, landscapes, l2_mat,
    bottleneck!, bottleneck_mat

const DIMS = isdefined(Main,:DIMS) ? Main.DIMS : 0:1

R"""
library(TDA)
"""

empty(x) = sum(map(length,values(x))) == 0

d_bcode(R,d) = (b = R[:barcode][d]; length(b) == 0 ? [d 0.0 0.0] : [d*ones(size(b)[1]) b])
d_bcodes(R) = vcat([d_bcode(R,d) for d in keys(R[:barcode])]...)#filter(x->!empty(R[:barcode][x]),keys(R[:barcode]))]...)

function filter_bcodes(R,L,dims=DIMS)
    filt = filter(x->(!empty(R[x][:barcode])),1:length(R))
    R[filt],L[filt]
end

function landscape!(R,dims=DIMS)
    dim = maximum(dims)
    bcode = d_bcodes(R)
    R"""
    diag <- $bcode
    dim <- $dim
    colnames(diag) <- c("dimension", "birth", "death")
    land <- landscape(diag, dimension = dim, KK = 1)
    """
    @rget land
end

function landscapes(R,dims=DIMS)
    n = length(R)
    p = Progress(n,1)
    println("$n landscapes $dims")
    hcat([(next!(p);landscape!(r,dims)) for r in R]...).'
end

function l2_mat(S)
    m = size(S)[1]
    M = zeros(m,m)
    _m = Int(m*(m-1)/2)
    p = Progress(_m,1)
    println("$(m)x$(m) l2 distance matrix")
    for i=1:m
        for j=i+1:m
            next!(p)
            d = norm(S[i,:] - S[j,:])
            M[i,j] = d
            M[j,i] = d
        end
    end
    M
end

function bottleneck!(R1, R2; dims=DIMS)
    # try
        bcode1,bcode2 = map(x->d_bcodes(x),(R1,R2))
        R"""
        bottleneck_d <- bottleneck($bcode1, $bcode2, dimension=$dims)
        """
    # catch err
    #     for R in (R1,R2)
    #         println("\n\n --- BARCODES ---")
    #         for key in keys(R[:barcode])
    #             println("\n$key")
    #             println(R[:barcode][key])
    #         end
    #     end
    #     println(err)
    #     exit()
    # end
    @rget bottleneck_d
end

function bottleneck_mat(R;dims=DIMS)
    m = length(R)
    M = zeros(m,m)
    _m = Int(m*(m-1)/2)
    p = Progress(_m,1)
    println("$(m)x$(m) bottleneck distance matrix")
    for i=1:m
        for j=i+1:m
            next!(p)
            d = bottleneck!(R[i],R[j])
            M[i,j] = d
            M[j,i] = d
        end
    end
    M
end

end
