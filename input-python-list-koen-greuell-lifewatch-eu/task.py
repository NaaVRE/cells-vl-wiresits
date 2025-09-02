
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




list_ = [1,2,3]

file_list_ = open("/tmp/list__" + id + ".json", "w")
file_list_.write(json.dumps(list_))
file_list_.close()
