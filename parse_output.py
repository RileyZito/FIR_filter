import datetime
import fileinput
import os
import re

now_fmt = "%y-%M-%d-%h-%m-%s"


def main():
    # Make a results folder if one does not exist
    if not os.path.exists("results"):
        os.mkdir("results")

    # Open a new file in the results folder whose name contains the date and time
    with open(os.path.join("results", f"results_{datetime.datetime.now().strftime(now_fmt)}.csv"), "w") as f:
        # Loop will run until eof
        for line in fileinput.input():
            print(line, end="")  # echo the output to the terminal

            # Check to see if the line contains two integers separated by a comma (and with arbitrary whitespace
            # padding)
            if len(re.findall(r"^[\s\d]+,[\s\d]+$", line)) != 1:
                continue

            # Match the integers and concatenate them into a new line in the output file
            values = re.findall(r"((?=\s*)\d+)", line)
            f.writelines([",".join(values) + "\n"])


if __name__ == "__main__":
    main()
