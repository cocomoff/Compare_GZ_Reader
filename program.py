import glob
import gzip
import json
from tqdm import tqdm

def main(tuser):
    fn_ans = f"data/{tuser}.csv"
    ans_ids = set({})
    with open(fn_ans, "r") as f:
        for line in f:
            line = line.strip()
            ans_ids.add(int(line))
    
    # gzファイル
    all_user_ids = set({})
    for line in tqdm(sorted(glob.glob("data/meta/*"))):
        with gzip.open(line, "tr") as f:
            for line_j in f:
                line_j = line_j.strip()
                data = json.loads(line_j)
                uid = data["uid"]
                pid = int(data["photoid"])
                if uid == tuser:
                    all_user_ids.add(pid)

    print(len(ans_ids))
    print(len(all_user_ids))
    print(len(all_user_ids & ans_ids))


if __name__ == '__main__':
    tuser = "61585804@N00"
    main(tuser)