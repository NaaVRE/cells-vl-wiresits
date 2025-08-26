
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




data_ = ["294hans390", "432griet43"]

file_data_ = open("/tmp/data__" + id + ".json", "w")
file_data_.write(json.dumps(data_))
file_data_.close()
