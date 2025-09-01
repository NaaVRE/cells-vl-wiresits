
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--data_', action='store', type=str, required=True, dest='data_')

arg_parser.add_argument('--processed_data', action='store', type=str, required=True, dest='processed_data')


args = arg_parser.parse_args()
print(args)

id = args.id

data_ = json.loads(args.data_)
processed_data = json.loads(args.processed_data)



print(f"successfully processed {data_=} into {processed_data}")

