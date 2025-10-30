# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+-..             .-*####################################
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*                  ..-####################################
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%=.                  .-*####################################
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%.                       .=##################################
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#.                        .###################################
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*                          =##################################
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.                     ..:::##################################
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+                     ..=::##################################
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:                    ..: .=#################################
# @@@@@@@@@@@@@@@@@@@@@@@@@@#:#@#++#@@@@@*%=.                       .-################################
# @@@@@@@@@@@@@@@@@@@@@@@@*.-%=*+=-..  ......                       :-################################
# @@@@@@@@@@@@@@@@@@@@@@+-%@%:..-%@@@@+.:*#:                        :#################################
# @@@@@@@@@@@@@@@@@@@@@+%@@@@+.    ..+@@@%:.                       .=#################################
# @@@@@@@@@@@@@@@@@@@@@@@@@#::+==*#%@@@*...-.                      :*#################################
# @@@@@@@@@@@@@@@@@@@@@@@@*%@@@@@@@@%:.:-==..:+-           .=**+-:-+##################################
# @@@@@@@@@@@@@@@@@@@@@@@@@@%+=#@@#-:....:+%@*..          -###########################################
# @@@@@@@@@@@@@@@@@@@@@@@@+.=##%%--#@@@@@@@#.            :*###########################################
# @@@@@@@@@@@@@@@@@@@@@@@%%@@@@@#%@@@@@@*-..             :*###########################################
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#-.                    ..=*#######################################


####### Dites Bonjour à l'Académie Franc C'aise, notre objectif est de nous assurer que votre code
####### répond à nos standards.

from pathlib import Path
from typing import List
import sys
import os
import subprocess

############ Variables constantes #############

testFolderPath = 'fcc_src/larousse'
vmExecutablePath = "fcvm"
compilerExecutablePath = "fcc"
binaryNameFc = "a.fcp"
binaryNameC = "a.out"

##########################################


############ Variables globales #############

testFolders = []

##########################################

############ Fonctions utilitaires de dossier #############

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

def get_all_files_by_extension_in_folder(folder: str, extension: str) -> List[str]:
    folder_path = Path(folder)
    files = []

    for file in folder_path.iterdir():
        if file.is_file() and file.suffix == extension:
            files.append(file)
    return files

def does_file_exist(path: str) -> bool:
    return Path(path).is_file()

##########################################


############ Fonctions utiliatires de test #############

def register_valid_folders(subfolders: List[str]):
    global testFolders

    for testFolder in subfolders:
        if not has_any_file_with_extension_in_folder(testFolder, ".fr"):
            print(f"[!] [Académie Franc C'aise] Aucun fichier '.fr' trouvé dans '{testFolder.name}', le dossier ne sera donc pas pris en compte.", file=sys.stderr)
            continue
        if not has_any_file_with_extension_in_folder(testFolder, ".c"):
            print(f"[!] [Académie Franc C'aise] Aucun fichier '.c trouvé dans ' {testFolder.name}, le dossier ne sera donc pas pris en compte.", file=sys.stderr)
            continue
        if not does_folder_exist(testFolder + "/test"):
            print(f"[!] [Académie Franc C'aise] Aucun dossier 'test' trouvé dans {testFolder.name}, le dossier ne sera donc pas pris en compte.", file=sys.stderr)
        if not has_any_file_with_extension_in_folder(testFolder + "/test", ".fr"):
            print(f"[!] [Académie Franc C'aise] Aucun fichier '.fr' trouvé dans '{testFolder.name}/test', le dossier ne sera donc pas pris en compte.", file=sys.stderr)
            continue
        if not has_any_file_with_extension_in_folder(testFolder + "/test", ".c"):
            print(f"[!] [Académie Franc C'aise] Aucun fichier '.c trouvé dans ' {testFolder.name}/test, le dossier ne sera donc pas pris en compte.", file=sys.stderr)
            continue
        print(f"[*] [Académie Franc C'aise] Le dossier {testFolder.name} a été enregistré !")
        testFolders.append(testFolder)

def can_start_testing() -> bool:
    global testFolders

    return len(testFolders) > 0

def get_lisp_code_file(folder: str) -> str:
    return get_any_file_by_extension_in_folder(folder, ".scm")

def get_expected_result_file(folder: str) -> str:
    return get_any_file_by_extension_in_folder(folder, ".txt")

def is_franc_c_built() -> bool:
    global vmExecutablePath
    global compilerExecutablePath

    file = Path(vmExecutablePath)
    secondFile = Path(compilerExecutablePath)
    return file.is_file() and os.access(file, os.X_OK) and secondFile.isfile() and os.access(secondFile, os.X_OK)

def build_franc_c() -> bool:

    p1 = subprocess.Popen(["make"], stdout=subprocess.PIPE)
    p1.stdout.close()

    _, err = p2.communicate()
    return err.decode("utf-8") == 0

def read_file(fileName: str) -> str:
    with open(fileName, 'r', encoding='utf-8') as file:
        return file.read()

def compile_test_fc(testFolder: str) -> int:
    global compilerExecutablePath

    fcFiles = get_all_files_by_extension_in_folder(testFolder, ".fr") + get_all_files_by_extension_in_folder(testFolder + "/test", ".fr")

    p1 = subprocess.Popen(["./" + compilerExecutablePath] + fcFiles, stdout=subprocess.PIPE)
    p1.stdout.close()

    _, err = p2.communicate()
    return err.decode("utf-8") == 0 and does_file_exist(binaryNameFc)

def clean_test_fc() -> None:
    try:
        os.remove(binaryNameFc)
        os.remove(binaryNameC)
    except Exception as ignore:
        pass

def get_vm_output(testFile: str) -> str:
    global gladosExecutableName

    p1 = subprocess.Popen(["cat", testFile], stdout=subprocess.PIPE)
    p2 = subprocess.Popen([f"./{gladosExecutableName}"], stdin=p1.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    p1.stdout.close()

    output, _ = p2.communicate()
    output = output.decode("utf-8").replace('> ', '')
    return output

def test_folder(testFolder: str) -> bool:

    if not compile_test_fc(testFolder):
        print(f"[*] [Académie Franc C'aise] Les dossiers soruces '.fr' n'ont pas pu être compilés {testFolder}, le test est donc raté !")
        return False

    return True

##########################################

############ Main Program ################

def start_academie_franc_c_aise():
    global vmExecutablePath
    global compilerExecutablePath
    global testFolderPath
    global testFolders

    print("[*] [Académie Franc C'aise] Mesdames, messieurs, attendez un instant..\n")

    if not is_franc_c_built():
        print(f"[!] [Académie Franc C'aise] Ayant été dans l'incapacité de trouver les fichiers exécutables suivant : [{vmExecutablePath}, {compilerExecutablePath}], nous nous voyons obligé de nous offrir la permission de les construire, étants nécessaires au bon fonctionnement du programme.")

        if not build_franc_c() or not is_franc_c_built():
            print(f"[!] [Académie Franc C'aise] Malgré avoir tant bien que mal essayé de construire les fichiers binaires requis au bon fonctionnement de ce programme, nous avons malheureusement échoué, le programme va donc s'arrêter.")
            exit(84)
    if not does_folder_exist(testFolderPath):
        print(f"[!] [Académie Franc C'aise] Nous n'avons pas pu trouver le dossier à tester '{testFolderPath}', le programme va donc s'arrêter.")
        exit(84)
    register_valid_folders(get_subfolders(testFolderPath))
    print(f"\n[*] [Académie Franc C'aise] Nous avons pu trouver {len(testFolders)} dossiers à tester !")
    if not can_start_testing():
        print(f"[!] [Académie Franc C'aise] Le programme va donc s'arrêter puisqu''il n'y a aucun dossier à tester.")
        exit(84)
    print("\n[*] [Académie Franc C'aise] Nous sommes prêts à lancer les tests !..\n")

    passedTest = 0

    for folderToTest in testFolders:
        print(f"[*] [Académie Franc C'aise] Nous testons {folderToTest.name}..")
        if (test_folder(folderToTest)):
            passedTest += 1
        clean_test_fc()
    print(f"\n[*] [Académie Franc C'aise] ({passedTest}/{len(testFolders)}) tests passés !")
    if passedTest != len(testFolders):
        exit(84)


if __name__ == "__main__":
    start_academie_franc_c_aise()

##########################################
