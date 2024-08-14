from argparse import ArgumentParser

def main(name):
    print(f"Hello, {name}!")

if __name__ == "__main__":
    parser = ArgumentParser(description="Prints a personalized greeting.")
    # parser.add_argument("--name", required=True, help="Name to greet")
    parser.add_argument(
        "--coding_type", nargs="+", required=True, help="List of coding types"
    )
    args = parser.parse_args()
    print(str(args.coding_type))
    # main(args.name)
