import datetime
import fileinput
import os
import re

now_fmt = "%y-%M-%d-%h-%m-%s"


def main():
    # Loop will run until eof
    if not os.path.exists("results"):
        os.mkdir("results")

    with open(os.path.join("results", f"results_{datetime.datetime.now().strftime(now_fmt)}.csv"), "w") as f:
        for line in fileinput.input():
            print(line, end="")
            if len(re.findall(r"[\s\d]+,[\s\d]+", line)) != 1:
                continue
            values = re.findall(r"((?=\s*)\d+)", line)
            f.writelines([",".join(values) + "\n"])


if __name__ == "__main__":
    main()
