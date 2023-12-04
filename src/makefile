
# Compiler
SWIPL = swipl

# Source file
SOURCE = Loja_de_Perfumes.pl

# Target executable
TARGET = main

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(SWIPL) -o $(TARGET) -c $(SOURCE)

run:
	./$(TARGET)

clean:
	rm -f $(TARGET)
