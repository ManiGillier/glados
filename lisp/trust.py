
# This is the trust, the VERY FAMOUS python haskell glados debugger !

# Say hi to trust :)

def trust(input_path, output_path):
    with open(input_path, 'r', encoding='utf-8') as f:
        content = f.read()

    flattened = content.replace('"', r'\"').replace('\n', '').replace('\t', '')

    final_output = f'"{flattened}"'

    with open(output_path, 'w', encoding='utf-8') as out:
        out.write(final_output)

if __name__ == "__main__":
    trust('test.lsp', 'test.txt')

# Trust is actually The Robust Unfolding Syntax Tester
