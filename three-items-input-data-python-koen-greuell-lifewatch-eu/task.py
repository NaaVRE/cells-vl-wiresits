
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




list2 = ["0001", "0010", "0011"]

file_list2 = open("/tmp/list2_" + id + ".json", "w")
file_list2.write(json.dumps(list2))
file_list2.close()
