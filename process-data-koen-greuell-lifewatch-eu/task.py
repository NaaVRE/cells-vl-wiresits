
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--item', action='store', type=str, required=True, dest='item')


args = arg_parser.parse_args()
print(args)

id = args.id

item = args.item.replace('"','')



processed_item = ''.join(char for char in item if char.isalpha())

file_processed_item = open("/tmp/processed_item_" + id + ".json", "w")
file_processed_item.write(json.dumps(processed_item))
file_processed_item.close()
