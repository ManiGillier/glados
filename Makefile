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
	curl -sSL https://get.haskellstack.org/ | sh

tests_run:
	make all

clean:
	rm -rf $(EXEC)

fclean:
	rm -rf $(EXEC)
	stack clean

re:		clean all

.PHONY: 	clean all
