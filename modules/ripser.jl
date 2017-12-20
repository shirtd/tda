__precompile__()

module Ripser

using ProgressMeter

export _rc, getdim, ripser, ripsers, noinf

const DIM = isdefined(Main,:DIM) ? Main.DIM : 2
const DIMS = isdefined(Main,:DIMS) ? Main.DIMS : 0

const _rc = sqrt(2*DIM/(DIM+1))/2
const lower = Dict{Symbol,Function}(:matrix=>(M)->[[M[i,j] for j=1:i-1] for i=1:size(M)[1]],
		:l2_points=>(P)->[[norm(P[:,i] - P[:,j]) for j=1:i-1] for i=1:size(P)[2]],
		:points=>(P)->[[sqrt(2*size(P)[1]/(size(P)[1]+1))/2*norm(P[:,i] - P[:,j]) for j=1:i-1] for i=1:size(P)[2]],
		:rc_points=>(P)->[[_rc*norm(P[:,i] - P[:,j]) for j=1:i-1] for i=1:size(P)[2]])

# ripsin = Dict(T=>(D)->replace("$(lower[T](D))","], [",",\n")[26:end-2] for T in keys(lower))
ripsin = Dict(T=>(D->join("$(join("$d," for d in r ))\n" for r in lower[T](D))) for T in keys(lower))
run!(e,s) = (println(e[2],s); close(e[2]); readstring(e[1]))
ripser!(D,T=:points;dim=1) = run!(readandwrite(`ripser --dim $dim`),ripsin[T](D))

T_str = Dict(:points=>(D)->"$(size(D)[2]) points in R$(size(D)[1])",
		:matrix=>(D)->"$(size(D)[1]) point distance matrix")

noinf(bcode) = length(bcode) > 0 ?  bcode[filter(i->!(Inf in bcode[i,:]),1:size(bcode)[1]),:] : []

function getdim(R,dim;inf=false)
	dims = filter(x->dim in collect(keys(x[:barcode])),R)
	map(x->inf ? x[:barcode][dim] : noinf(x[:barcode][dim]),dims)
end

function ripser(D,T=:l2_points;dim=maximum(DIMS),time=false,verb=false,trans=true)
    verb ? print(" $(T_str[T](D))") : 0
	D = trans ? D.' : D
	if time
    	@time stdin = ripser!(D,T,dim=dim)
	else
		stdin = ripser!(D,T,dim=dim)
	end
    n = parse(Int,match(r"(?<=distance matrix with )(.*)(?= points)",stdin).match)
    llim,ulim = map(s->parse(Float32,s),split(match(r"(?<=value range: \[)(.*)(?=\])",stdin).match,","))
    dims = map(s->parse(Int,s),matchall(r"(?<=persistence intervals in dim )(.*)(?=:)",stdin))
    parse_floats(strs) = map(x->(v=tryparse(Float64,x); isnull(v) ? Inf : get(v)),strs)
    str_to_pairs(str) = map(s->parse_floats(split(s,",")),matchall(r"(?<= \[)(.*)(?=\))",str))
    pairs = [str_to_pairs(str) for str in split(stdin, r"persistence intervals in dim .*?:")[2:end]]
    barcode = Dict(dims[j]=>noinf([pair[i] for pair in pairs[j], i in 1:2]) for j=1:length(dims))
	max = -Inf
	for dim in dims
		if length(barcode[dim]) > 0
			mx = maximum(filter(x->(x<Inf),barcode[dim]))
			max = mx > max ? mx : max
		end
	end
    Dict(:n=>n,:lims=>(llim,ulim),:max=>max,:dims=>dims,:barcode=>barcode,:D=>D,:T=>T)
end

function ripsers(Ds,T=:points;dim=maximum(DIMS),time=false,verb=false,prog=true,trans=true)
	Ds = ndims(Ds) > 1 ? [Ds[i,:] for i=1:size(Ds)[1]] : Ds
	f(x) = ripser(x,T,dim=dim,time=time,verb=verb,trans=trans)
	println("$(length(Ds)) $(size(Ds[1])[2])D persistence diagrams 0:$dim")
	if prog
		p = Progress(length(Ds),1)
		return [(next!(p); f(D)) for D in Ds]
	else
		return [f(D) for D in Ds]
	end
end

end
