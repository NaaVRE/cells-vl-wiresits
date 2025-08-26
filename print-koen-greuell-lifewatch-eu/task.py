
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--name', action='store', type=str, required=True, dest='name')


args = arg_parser.parse_args()
print(args)

id = args.id

name = args.name.replace('"','')



print(name)
done_executing = 1

file_done_executing = open("/tmp/done_executing_" + id + ".json", "w")
file_done_executing.write(json.dumps(done_executing))
file_done_executing.close()
