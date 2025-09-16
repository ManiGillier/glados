##
## EPITECH PROJECT, 2025
## Makefile
## File description:
## PROJECT
##

EXEC_BASE = glados-exe

EXEC = glados

all:
	stack build
	cp $$(stack path --local-install-root)/bin/$(EXEC_BASE) .
	mv $(EXEC_BASE) $(EXEC)

run:
	stack exec $(EXEC)

install:
	# install ghcup
	curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
	# Set version
	ghcup install ghc 9.10.2 && ghcup set ghc 9.10.2
	ghcup --url-source=https://raw.githubusercontent.com/haskell/ghcup-metadata/master/ghcup-vanilla-0.0.9.yaml install hls 2.11.0.0 && ghcup set hls 2.11.0.0
	ghcup install stack 3.7.1

tests_run:
	make all

clean:
	rm -rf $(EXEC)

fclean:
	rm -rf $(EXEC)
	stack clean

re:		clean all

.PHONY: 	clean all
