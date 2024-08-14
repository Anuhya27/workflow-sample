import sys

def main(name):
    print(f"Hello, {name}!")

if __name__ == "__main__":
    # Check if an argument is provided
    if len(sys.argv) != 2:
        print("Usage: python hello.py <name>")
        sys.exit(1)

    name = sys.argv[1]
    main(name)