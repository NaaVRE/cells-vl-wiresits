
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--done_executing', action='store', type=int, required=True, dest='done_executing')

arg_parser.add_argument('--name_list', action='store', type=str, required=True, dest='name_list')


args = arg_parser.parse_args()
print(args)

id = args.id

done_executing = args.done_executing
name_list = json.loads(args.name_list)



if done_executing == 1:
    print(f"successfully printed {name_list=}")
else:
    print("failed")

