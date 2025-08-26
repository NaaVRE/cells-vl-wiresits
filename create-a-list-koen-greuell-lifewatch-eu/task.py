
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




name_list = ["hans", "griet"]

file_name_list = open("/tmp/name_list_" + id + ".json", "w")
file_name_list.write(json.dumps(name_list))
file_name_list.close()
