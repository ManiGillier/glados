## EPITECH PROJECT, 2025
## Glados
## File description:
## Makefile fcvm
##

COMPILED_NAME	:= fcvm
NAME	:= fcvm

all:
	$(RM) $(NAME)
	$(MAKE) $(NAME)

$(NAME):
	stack build --allow-different-user
	ln -s `stack path --local-install-root`/bin/$(COMPILED_NAME)-exe $@

tests_run:
	mkdir -p test/coverage
	stack clean --allow-different-user
	stack test --coverage --allow-different-user
	stack hpc report --all --destdir test/coverage --allow-different-user

tests_open:
	make -s tests_run
	xdg-open `stack path --local-hpc-root`/index.html

fclean:
	stack clean
	$(RM) $(NAME)
	rm -rf test/coverage

re: fclean $(NAME)

.PHONY: all fclean re
