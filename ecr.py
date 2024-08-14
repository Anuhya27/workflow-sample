from argparse import ArgumentParser

def main(name):
    print(f"Hello, {name}!")

if __name__ == "__main__":
    parser = ArgumentParser(description="Prints a personalized greeting.")
    parser.add_argument("--name", required=True, help="Name to greet")
    args = parser.parse_args()

    main(args.name)
    