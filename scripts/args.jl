using ArgParse

ARG_s = ArgParseSettings("bottleneck distance tSNE tests on MNIST data")
@add_arg_table ARG_s begin
    # PARAMETERS
    "--DIMS","-D"
        nargs = 2
        default = [0,2]
        arg_type = Int
        help = "diagram dimensions"
    "--DIM","-d"
        default = 2
        arg_type = Int
        help = "tSNE dimension"
    "--N","-n"
        default = 1000
        arg_type = Int
        help = "total number of samples (MAX 60K)"
    "--K","-k"
        default = 1
        arg_type = Int
        help = "diagrams per digit (class)"
    # OPTIONS
    "--run-all","-a"
        action = :store_true
        help = "run all pairwise bottleneck distance tSNE tests on MNIST data"
    "--run-raw","-R"
        action = :store_true
        help = "K (N/K)-point persistence diagrams per raw digit (class)"
    "--run-k","-K"
        action = :store_true
        help = "K (N/K)-point persistence diagrams per tSNE digit (class)"
    "--run-one","-O"
        action = :store_true
        help = "K (N/K)-point persistence diagrams per digit (class) from N-point tSNE"
    "--ion"
        action = :store_true
        help = "show plot"
    "--save","-S"
        action = :store_true
        help = "save plot and data"
    "--test","-T"
        action = :store_true
        help = "save plot and data, don't show plot and exit"
end

args = parse_args(ARGS[2:end], ARG_s)
rng(t) = t[1]:t[2]

const SYMB = (:raw,:k,:one)
const STR = ("run-raw","run-k","run-one")
const RUNS = [args[s] for s in STR]
const ALL = args["run-all"] || !any(RUNS)
const RUN = Dict(t[1]=>t[2] for t in zip(SYMB,map(x->(ALL?true:x),RUNS)))
const DIMS = args["DIMS"][1]:args["DIMS"][2]
const TEST = args["test"]
const ION = args["ion"]
const SAVE = TEST || args["save"]
const DIM = args["DIM"]
const N = args["N"]
const K = args["K"]
