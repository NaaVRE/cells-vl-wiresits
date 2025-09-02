
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--list_', action='store', type=str, required=True, dest='list_')


args = arg_parser.parse_args()
print(args)

id = args.id

list_ = json.loads(args.list_)



results = []
for x in list_:
    results.append(x+1)
    

file_results = open("/tmp/results_" + id + ".json", "w")
file_results.write(json.dumps(results))
file_results.close()
