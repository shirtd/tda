#!/usr/local/bin/julia -iLscripts/args.jl
include("scripts/init.jl")

d = (raw!(),ktsne!(),onetsne!())

if SAVE && ALL
    dx(x) = Dict(y[1]=>y[2][x] for y in zip(SYMB,d))
    D,S = map(dx,(:data,:stats))
    save!(D,S,plot=true)
end

TEST ? exit() : 0
