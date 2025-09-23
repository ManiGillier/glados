##
## EPITECH PROJECT, 2025
## Glados
## File description:
## Makefile
##

COMPILED_NAME	:= glados
NAME	:= glados

all:
	$(RM) $(NAME)
	$(MAKE) $(NAME)

$(NAME):
	stack build --allow-different-user
	ln -s `stack path --local-install-root`/bin/$(COMPILED_NAME)-exe $@

install:
	# install ghcup
	curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
	# Set version
	ghcup install ghc 9.10.2 && ghcup set ghc 9.10.2
	ghcup --url-source=https://raw.githubusercontent.com/haskell/ghcup-metadata/master/ghcup-vanilla-0.0.9.yaml install hls 2.11.0.0 && ghcup set hls 2.11.0.0
	ghcup install stack 3.7.1

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
