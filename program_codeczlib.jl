using ProgressBars
using JSON
using CodecZlib

function main(tuser)
    fn_tuser = "$(tuser).csv"
    ans_ids = Set{Int}()
    
    open("./data/$(fn_tuser)", "r") do fp
        for line in eachline(fp)
            line = parse(Int, line)
            push!(ans_ids, line)
        end
    end

    # globの変わりの雑な実装
    s = "0123456789abcdef"
    all_user_ids = Set{Int}()
    loops = [(c1, c2, c3) for c1 in s, c2 in s, c3 in s]
    for (c1, c2, c3) in ProgressBar(loops)
        path = "data/meta/$(c1)$(c2)$(c3).gz"
	    open(path, "r") do fp
	        for line in eachline(GzipDecompressorStream(fp))
	            data = JSON.parse(line)
		        uid = data["uid"]
		        pid = data["photoid"]
		        (uid == tuser) && push!(all_user_ids, pid)
	        end
	    end
    end

    println(length(ans_ids))
    println(length(all_user_ids))
    println(length(intersect(all_user_ids, ans_ids)))
end

main("61585804@N00")