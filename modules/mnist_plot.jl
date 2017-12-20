module MNISTPlot

using MNIST

export rescale, _DATA, DATA,
    _LABELS, LABELS, LABEL,
    plt, ax, bylabel, scatter!

const DIM = isdefined(Main,:DIM) ? Main.DIM : 2
const N = isdefined(Main,:N) ? Main.N : 1000
const ION = isdefined(Main,:ION) ? Main.ION : true

function rescale(A, dim::Integer=1)
    res = A .- mean(A, dim)
    res ./= map(x -> x > 0.0 ? x : 1.0, std(A, dim))
    res
end

function bylabel(X,L)
    D = [[] for l in LABEL]
    map(i->push!(D[L[i]],X[i,:]),1:length(L))
    [hcat(d...).' for d in D]
end

import PyPlot
const plt = PyPlot

ION ? plt.ion() : plt.ioff()

_DATA, _LABELS = traindata()
const LABEL = collect(1:10)
const COLOR = [plt.cm[:gist_rainbow](linspace(0,1,length(LABEL)))[i,1:3] for i=1:10]

LABELS = [Int(l+1) for l in _LABELS[1:N]]
DATA = rescale(_DATA[:, 1:N].')

fig = plt.figure(1,figsize=(10,3))
# ax = map(x->DIM > 2 ? plt.subplot(x, projection="3d") : plt.subplot(x),(121,122))
ax = map(x->DIM > 2 ? plt.subplot(x, projection="3d") : plt.subplot(x),(131,132,133))
# map(x->x[:axis]("equal"),ax)
plt.tight_layout()

function scatter!(axis,P,L;s=25,a=0.5,title=nothing)
    n,m = (length(L),size(P))
    P = n != m[1] ? (n != m[2] ? (println("labels do not match"); nothing) : P.') : P
    ploti(i) = axis[:scatter](P[i,:]...,s=s,alpha=a,c=COLOR[L[i]],marker="\$$(L[i]-1)\$")
    P != nothing ? [ploti(i) for i=1:n] : P
    title != nothing ? axis[:set_title](title) : nothing
    plt.tight_layout()
end

end
