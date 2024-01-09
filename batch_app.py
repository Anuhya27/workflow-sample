import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--user_input")

args = parser.parse_args()

if args.user_input is None:
    print('The user input is none.')
else:
    print(f'The user input is {args.user_input}')