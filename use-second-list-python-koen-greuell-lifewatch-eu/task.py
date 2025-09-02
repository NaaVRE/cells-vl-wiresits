
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--list1', action='store', type=str, required=True, dest='list1')

arg_parser.add_argument('--list2', action='store', type=str, required=True, dest='list2')


args = arg_parser.parse_args()
print(args)

id = args.id

list1 = json.loads(args.list1)
list2 = json.loads(args.list2)



print(list1)
print(list2)

