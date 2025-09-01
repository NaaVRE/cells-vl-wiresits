
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



processed_data = []
for item in data_:
    processed_item = ''.join(char for char in item if char.isalpha())
    processed_data.append(processed_item)

file_processed_data = open("/tmp/processed_data_" + id + ".json", "w")
file_processed_data.write(json.dumps(processed_data))
file_processed_data.close()
file_processed_item = open("/tmp/processed_item_" + id + ".json", "w")
file_processed_item.write(json.dumps(processed_item))
file_processed_item.close()
