###########################################
#  Say Hello to the [GaySex] Program !    #
#  Glados Amazing Yet Simple Evaluator X  #
###########################################

from pathlib import Path
from typing import List
import sys
import os
import subprocess

############ Const Variables #############

testFolderPath = 'test/test-list'
gladosExecutableName = "glados"

##########################################


############ Global Variables #############

testFolders = []

##########################################

############ Folder Utils #############

def does_folder_exist(path: str) -> bool:
    return Path(path).is_dir()

def get_subfolders(path: str) -> List[str]:
    return [f for f in Path(path).iterdir() if f.is_dir()]

def has_any_file_with_extension_in_folder(folder: str, extension: str) -> bool:
    return any(file.suffix == extension for file in folder.iterdir() if file.is_file())

def get_folder_file_count(folder: str) -> int:
    return sum(1 for file in folder.iterdir() if file.is_file())

def get_any_file_by_extension_in_folder(folder: str, extension: str) -> bool:
    folder_path = Path(folder)

    for file in folder_path.iterdir():
        if file.is_file() and file.suffix == extension:
            return file
    return None

##########################################


############ Test Utils #############

def register_valid_folders(subfolders: List[str]):
    global testFolders

    for testFolder in subfolders:
        if not has_any_file_with_extension_in_folder(testFolder, ".txt"):
            print(f"[!] [Gay-Sex] Could not register test folder '{testFolder.name}', no expected result ('.txt') file found.", file=sys.stderr)
            continue
        if not has_any_file_with_extension_in_folder(testFolder, ".scm"):
            print(f"[!] [Gay-Sex] Could not register test folder {testFolder.name}, no expected code to run ('.scm') file found.", file=sys.stderr)
            continue
        if get_folder_file_count(testFolder) != 2:
            print(f"[!] [Gay-Sex] Could not register test folder {testFolder.name}, found more than two files ('.txt', '.scm').", file=sys.stderr)
            continue
        print(f"[*] [Gay-Sex] Registered test folder {testFolder.name} !")
        testFolders.append(testFolder)

def can_start_testing() -> bool:
    global testFolders

    return len(testFolders) > 0

def get_lisp_code_file(folder: str) -> str:
    return get_any_file_by_extension_in_folder(folder, ".scm")

def get_expected_result_file(folder: str) -> str:
    return get_any_file_by_extension_in_folder(folder, ".txt")

def is_glados_built() -> bool:
    global gladosExecutableName

    file = Path(gladosExecutableName)
    return file.is_file() and os.access(file, os.X_OK)

def read_file(fileName: str) -> str:
    with open(fileName, 'r', encoding='utf-8') as file:
        return file.read()
    
def get_glados_output(testFile: str) -> str:
    global gladosExecutableName

    p1 = subprocess.Popen(["cat", testFile], stdout=subprocess.PIPE)
    p2 = subprocess.Popen([f"./{gladosExecutableName}"], stdin=p1.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    p1.stdout.close()

    output, _ = p2.communicate()
    output = output.decode("utf-8").replace('> ', '')
    return output

def test_folder(testFolder: str) -> bool:
    expectedResult = read_file(get_expected_result_file(testFolder))
    gladosOutput = get_glados_output(get_lisp_code_file(testFolder))

    if expectedResult == gladosOutput:
        print(f"[*] [Gay-Sex] Test {testFolder} passed !")
        return True
    else:
        print(f"[!] [Gay-Sex] Test {testFolder} did not pass.", file=sys.stderr)

        print("\nGot:\n")
        print(gladosOutput.rstrip(), file=sys.stderr)
        print("\nBut expected:\n", file=sys.stderr)
        print(expectedResult.rstrip(), file=sys.stderr)
        print(("--------"), file=sys.stderr)

        return False

##########################################

############ Main Program ################

def start_gay_sex():
    global gladosExecutableName
    global testFolderPath
    global testFolders

    print("[*] [Gay-Sex] Starting Gay Sex..\n")

    if not is_glados_built():
        print(f"[!] [Gay-Sex] Could not find executable f{gladosExecutableName}, please build it, aborting..")
        exit(84)
    if not does_folder_exist(testFolderPath):
        print(f"[!] [Gay-Sex] Could not find test folder '{testFolderPath}', aborting..")
        exit(84)
    register_valid_folders(get_subfolders(testFolderPath))
    print(f"\n[*] [Gay-Sex] Found {len(testFolders)} test folders !")
    if not can_start_testing():
        print(f"[!] [Gay-Sex] Could not start testing, needs at least a single valid test folder, aborting..")
        exit(84)
    print("\n[*] [Gay-Sex] Running tests..\n")

    passedTest = 0

    for folderToTest in testFolders:
        print(f"[*] [Gay-Sex] Testing {folderToTest.name}..")
        if (test_folder(folderToTest)):
            passedTest += 1
    print(f"\n[*] [Gay-Sex] ({passedTest}/{len(testFolders)}) test passed !")
    if passedTest != len(testFolders):
        exit(84)


if __name__ == "__main__":
    start_gay_sex()

##########################################
