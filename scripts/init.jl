using Suppressor

# @suppress begin
map(x->include("$(pwd())/modules/$x"), readdir("$(pwd())/modules"))
# end

using Ripser, RTDA, MNISTPlot, Learn, TSne, ProgressMeter, JLD

const Q = Int(floor(N/K))
const datas = [DATA[Q*(i-1)+1:Q*i,:] for i=1:K]
const labels = [LABELS[Q*(i-1)+1:Q*i] for i=1:K]
const NAME = "$(N)_$(Q)x$(K)d$(DIM)D$(minimum(DIMS))-$(maximum(DIMS))"
const DIR = ".data"

const raw_title = "RAW BOTTLNECK TSNE"
const tsne_title = "$K TSNE BOTTLENECK TSNE"
const tsne1_title = "TSNE $K BOTTLENECK TSNE"

function run!(datas,labels)
    G = vcat([bylabel(z[1],z[2]) for z in zip(datas,labels)]...)
    L = repeat(LABEL,outer=K)
    R = ripsers(G)
    R, L = filter_bcodes(R,L)

    M = bottleneck_mat(R)
    P = tsne_d((M/maximum(M)).^2,DIM)
    Dict(:P=>P,:M=>M,:R=>R,:L=>L,:G=>G,:D=>datas)
end

function tsnes!(datas)
    p = Progress(length(datas))
    [(next!(p);tsne(dat,DIM,progress=false)) for dat in datas]
end

function tests!(d, title)
    print("\tlogistic ")
    lm,l = logistic(d[:P],d[:L])
    print("\tgradient ")
    gm,g = sgd(d[:P],d[:L])
    print("\tk-means ")
    km,k = kmeans(d[:P],d[:L])
    stats = Dict(:logistic=>l,:sgd=>g,:kmeans=>k)
end

function save!(D,S,suff="";name=NAME,folder=DIR,plot=false)#plots="$DIR/plots")
    name = "$name$suff"
    if plot
        mkpath("$DIR/plots")
        plot_file = "$DIR/plots/$name.pdf"
        println("\nsaving plot as $plot_file")
        plt.savefig(plot_file)
    end
    mkpath(folder)
    dat_file = "$folder/$name.jld"
    print("saving data as $dat_file")
    @time save(dat_file,"data",D,"stats",S)
end

function raw!()
    if RUN[:raw]
        println("\n$raw_title")
        # n = Int(floor(N/K))
        # datas = [DATA[n*(i-1)+1:n*i,:] for i=1:K]
        # labels = [LABELS[n*(i-1)+1:n*i] for i=1:K]
        d_raw = run!(datas,labels)
        scatter!(ax[1],d_raw[:P],d_raw[:L],title=raw_title)
        s_raw = tests!(d_raw,raw_title)
        SAVE ? save!(d_raw,s_raw,"raw") : 0
        return Dict(:data=>d_raw,:stats=>s_raw)
    else
        return nothing
    end
end

function ktsne!()
    if RUN[:k]
        println("\n$tsne_title")
        n = Int(floor(N/K))
        println("$K $n pt. t-SNEs")
        # datas = [DATA[n*(i-1)+1:n*i,:] for i=1:K]
        # labels = [LABELS[n*(i-1)+1:n*i] for i=1:K]
        tsnes = tsnes!(datas)
        d_tsne = run!(tsnes,labels)
        scatter!(ax[2],d_tsne[:P],d_tsne[:L],title=tsne_title)
        s_tsne = tests!(d_tsne,tsne_title)
        SAVE ? save!(d_tsne,s_tsne,"k") : 0
        return Dict(:data=>d_tsne,:stats=>s_tsne)
    else
        return nothing
    end
end

function onetsne!()
    if RUN[:one]
        println("\n$tsne1_title")
        println("$N pt. t-SNE")
        TSNE = tsne(DATA,DIM)
        n = Int(floor(N/K))
        tsnes1 = [TSNE[n*(i-1)+1:n*i,:] for i=1:K]
        d_tsne1 = run!(tsnes1,labels)
        scatter!(ax[3],d_tsne1[:P],d_tsne1[:L],title=tsne1_title)
        s_tsne1 = tests!(d_tsne1,tsne1_title)
        SAVE ? save!(d_tsne1,s_tsne1,"one") : 0
        return Dict(:data=>d_tsne1,:stats=>s_tsne1)
    else
        return nothing
    end
end
