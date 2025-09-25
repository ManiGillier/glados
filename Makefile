##
## EPITECH PROJECT, 2025
## glados
## File description:
## Makefile
##

PART_1	:= glados # Great Language Assembler Doctrined Over Seas
PART_2_COMPILER	:= fcc # Franc C Compiler
PART_2_VM	:= fcvm	# Franc C Virtual Machine

PART_1_DIR	:= lisp
PART_2_COMPILER_DIR	:= fcc_src
PART_2_VM_DIR	:= fcvm_src

all:
	$(MAKE) $(PART_1) $(PART_2_COMPILER) $(PART_2_VM)

re:
	$(MAKE) -C $(PART_1_DIR) fclean
	$(MAKE) -C $(PART_2_COMPILER_DIR) fclean
	$(MAKE) -C $(PART_2_VM_DIR) fclean
	$(MAKE) all

install:
# install ghcup
	curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
# Set version
	ghcup install ghc 9.10.2 && ghcup set ghc 9.10.2
	ghcup --url-source=https://raw.githubusercontent.com/haskell/ghcup-metadata/master/ghcup-vanilla-0.0.9.yaml install hls 2.11.0.0 && ghcup set hls 2.11.0.0
	ghcup install stack 3.7.1

$(PART_1):
	$(RM) $@
	$(MAKE) -C $(PART_1_DIR) $(PART_1)
	ln -s $(PART_1_DIR)/$(PART_1) $@
$(PART_2_COMPILER):
	$(RM) $@
	$(MAKE) -C $(PART_2_COMPILER_DIR) $(PART_2_COMPILER)
	ln -s $(PART_2_COMPILER_DIR)/$(PART_2_COMPILER) $@
$(PART_2_VM):
	$(RM) $@
	$(MAKE) -C $(PART_2_VM_DIR) $(PART_2_VM)
	ln -s $(PART_2_VM_DIR)/$(PART_2_VM) $@

tests_run:
	$(MAKE) -j -C $(PART_1_DIR) $@
	$(MAKE) -j -C $(PART_2_COMPILER_DIR) $@
	$(MAKE) -j -C $(PART_2_VM_DIR) $@

.PHONY: $(PART_1) $(PART_2_COMPILER) $(PART_2_VM) all install \
	tests_run re
