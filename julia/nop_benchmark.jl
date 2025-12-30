# nop_benchmark.jl
# Julia program to count 'NOPs' (empty statement) executed in 1 second

function nop_benchmark()
    nops = 0
    start = time()
    while time() - start < 1
        # NOP in Julia: empty statement
        nops += 1
    end
    println("NOPs executed: $nops")
end

nop_benchmark()
