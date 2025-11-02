
SRC	:= bytecode_reference/bytecode_reference.md \
	fcc_reference/fcc_reference.md \
	fcvm_reference/fcvm_reference.md \
	language_reference/language_reference.md \
	larousse_reference/larousse_reference.md \
	VM_Architecture_reference/VM_Architecture_reference.md

TMP_OBJ	:= $(SRC:.md=.org)
OBJ	:= $(notdir $(TMP_OBJ))

all: $(OBJ)

$(OBJ): $(TMP_OBJ)
	cp $^ .

fclean: clean

clean:
	$(RM) $(TMP_OBJ)
	$(RM) $(OBJ)

%.org: %.md
	pandoc $^ -o $@
