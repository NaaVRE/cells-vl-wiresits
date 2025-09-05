
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--data_', action='store', type=str, required=True, dest='data_')


args = arg_parser.parse_args()
print(args)

id = args.id

data_ = json.loads(args.data_)



for string_ in data_:
    print(string_)

