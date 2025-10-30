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
import time

############ Variables constantes #############

testFolderPath = 'larousse'
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
        if not does_folder_exist(str(testFolder) + "/test"):
            print(f"[!] [Académie Franc C'aise] Aucun dossier 'test' trouvé dans {testFolder.name}, le dossier ne sera donc pas pris en compte.", file=sys.stderr)
        if not has_any_file_with_extension_in_folder(testFolder / "test", ".fr"):
            print(f"[!] [Académie Franc C'aise] Aucun fichier '.fr' trouvé dans '{testFolder.name}/test', le dossier ne sera donc pas pris en compte.", file=sys.stderr)
            continue
        if not has_any_file_with_extension_in_folder(testFolder / "test", ".c"):
            print(f"[!] [Académie Franc C'aise] Aucun fichier '.c trouvé dans ' {testFolder.name}/test, le dossier ne sera donc pas pris en compte.", file=sys.stderr)
            continue
        print(f"[*] [Académie Franc C'aise] Le dossier {testFolder.name} a été enregistré !")
        testFolders.append(testFolder)

def can_start_testing() -> bool:
    global testFolders

    return len(testFolders) > 0


def is_franc_c_built() -> bool:
    global vmExecutablePath
    global compilerExecutablePath

    file = Path(vmExecutablePath)
    secondFile = Path(compilerExecutablePath)
    return file.is_file() and os.access(file, os.X_OK) and secondFile.is_file() and os.access(secondFile, os.X_OK)

def build_franc_c() -> bool:

    p1 = subprocess.Popen(["make"], stdout=subprocess.PIPE)

    p1.communicate()
    return p1.returncode == 0

def read_file(fileName: str) -> str:
    with open(fileName, 'r', encoding='utf-8') as file:
        return file.read()

def compile_test_fc(testFolder: str) -> int:
    global compilerExecutablePath

    fcFiles = get_all_files_by_extension_in_folder(testFolder, ".fr") + get_all_files_by_extension_in_folder(testFolder / "test", ".fr")

    if testFolder != Path(testFolderPath + "/afficher_nombre"):
        fcFiles += get_all_files_by_extension_in_folder(Path(testFolderPath + "/afficher_nombre"), ".fr")

    p1 = subprocess.Popen(["./" + compilerExecutablePath] + fcFiles, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    p1.communicate()

    return p1.returncode == 0 and does_file_exist(binaryNameFc)

def compile_test_c(testFolder: str) -> int:
    global compilerExecutablePath

    cFiles = get_all_files_by_extension_in_folder(testFolder, ".c") + get_all_files_by_extension_in_folder(testFolder / "test", ".c")

    p1 = subprocess.Popen(["gcc", "-I", str(testFolder / "include")] + cFiles, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    p1.communicate()

    return p1.returncode == 0 and does_file_exist(binaryNameC)

def clean_test_fc() -> None:
    try:
        os.remove(binaryNameFc)
        os.remove(binaryNameC)
    except Exception as ignore:
        pass

def get_franc_c_output() -> str:
    p1 = subprocess.Popen([f"./{vmExecutablePath}", binaryNameFc], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    output, _ = p1.communicate()
    output = output.decode("utf-8")
    return output


def get_c_output() -> str:
    p1 = subprocess.Popen([f"./{binaryNameC}"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    output, _ = p1.communicate()
    output = output.decode("utf-8")
    return output

def test_folder(testFolder: str) -> bool:

    startCompilationFc = time.time()
    if not compile_test_fc(testFolder):
        print(f"[*] [Académie Franc C'aise] Les dossiers sources '.fr' n'ont pas pu être compilés, le test est donc raté !")
        return False
    endCompilationFc = time.time()
    elapsedTimeFc = endCompilationFc - startCompilationFc
    print(f"[*] [Académie Franc C'aise] Les sources en \x1b[31mFranc C\x1b[0m ont pris \x1b[36m{endCompilationFc - startCompilationFc:.2f}s\x1b[0m à \x1b[33mcompiler\x1b[0m.")

    startCompilationC = time.time()
    if not compile_test_c(testFolder):
        print(f"[*] [Académie Franc C'aise] Les dossiers sources '.c' n'ont pas pu être compilés, le test est donc raté !")
        return False
    endCompilationC = time.time()
    print(f"[*] [Académie Franc C'aise] Les sources en \x1b[31mC\x1b[0m ont pris \x1b[36m{endCompilationC - startCompilationC:.2f}s\x1b[0m à \x1b[33mcompiler\x1b[0m.")

    fastestLanguage = "C" if endCompilationC - startCompilationC <= startCompilationFc - startCompilationFc else "Franc C"
    print(f"[*] [Académie Franc C'aise] Le langage \x1b[31m{fastestLanguage}\x1b[0m a été plus rapide à la \x1b[33mcompilation\x1b[0m de \x1b[36m{abs((endCompilationFc - startCompilationFc) - (endCompilationC - startCompilationC)):.2f}s\x1b[0m\n")

    startExecutionFc = time.time()
    outputFc = get_franc_c_output()
    endExecutionFc = time.time()
    print(f"[*] [Académie Franc C'aise] Les sources en \x1b[31mFranc C\x1b[0m ont pris \x1b[36m{endExecutionFc - startExecutionFc:.3f}s\x1b[0m à s'\x1b[33mexécuter\x1b[0m.")

    startExecutionC = time.time()
    outputC = get_c_output()
    endExecutionC = time.time()
    print(f"[*] [Académie Franc C'aise] Les sources en \x1b[31mC\x1b[0m ont pris \x1b[36m{endExecutionC - startExecutionC:.3f}s\x1b[0m à s'\x1b[33mexécuter\x1b[0m.")

    fastestLanguage = "C" if endExecutionC - startExecutionC <= endExecutionFc - startExecutionFc else "Franc C"
    print(f"[*] [Académie Franc C'aise] Le langage \x1b[31m{fastestLanguage}\x1b[0m a été plus rapide à l'\x1b[33mexécution\x1b[0m de \x1b[36m{abs((endExecutionC - startExecutionC) - (endExecutionFc - startExecutionFc)):.3f}s\x1b[0m\n")

    if outputFc != outputC:
        print(f"[*] [Académie Franc C'aise] Le programme \x1b[31mC\x1b[0m et \x1b[31mFranc C\x1b[0m n'ont pas produit le même \x1b[33mrésultat\x1b[0m.\n")

        print("[*] [Académie Franc C'aise] \x1b[31mFranc C\x1b[0m :")
        print(outputFc)
        print()
        print("[*] [Académie Franc C'aise] \x1b[31mC\x1b[0m :")
        print(outputC)

    return outputC == outputFc

def is_tool(name):
    from shutil import which

    return which(name) is not None

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
    if not is_tool("gcc"):
        print("[*] [Académie Franc C'aise] Afin d'utiliser ce programme, il vous faut avoir installer GCC, le programme va donc s'arrêter.\n")
    print(f"\n[*] [Académie Franc C'aise] Nous récupérons la liste des dossiers à tester..")
    register_valid_folders(get_subfolders(testFolderPath))
    print(f"\n[*] [Académie Franc C'aise] Nous avons pu trouver {len(testFolders)} dossiers à tester !")
    if not can_start_testing():
        print(f"[!] [Académie Franc C'aise] Le programme va donc s'arrêter puisqu''il n'y a aucun dossier à tester.")
        exit(84)
    print(testFolders)
    if not Path(testFolderPath + "/afficher_nombre") in testFolders:
        print(f"[!] [Académie Franc C'aise] Fonction triviale 'afficher_nombre' non trouvée, le programme va donc s'arrêter..")
        exit(84)
    print("\n[*] [Académie Franc C'aise] Nous sommes prêts à lancer les tests !..\n")

    passedTest = 0

    for folderToTest in testFolders:
        print(f"[*] [Académie Franc C'aise] Nous testons {folderToTest.name}..\n")
        if test_folder(folderToTest):
            passedTest += 1
            print(f"[*] [Académie Franc C'aise] Le test {folderToTest.name} est passé !\n")
        else:
            print(f"[!] [Académie Franc C'aise] Le test {folderToTest.name} n'est pas passé..\n")
        clean_test_fc()
        print("\n")
    print(f"\n[*] [Académie Franc C'aise] ({passedTest}/{len(testFolders)}) tests passés !")
    if passedTest != len(testFolders):
        exit(84)


if __name__ == "__main__":
    start_academie_franc_c_aise()

##########################################
