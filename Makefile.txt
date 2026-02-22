# ==== Compiler settings ====
CXX := g++
CXXFLAGS := -Wall -Wextra -Werror -std=c++17 -O2
TARGET := matrix_app

# ==== Directories ====
SRC_DIR := src
BUILD_DIR := build

# ==== Files ====
SRC := $(SRC_DIR)/main.cpp
OBJ := $(BUILD_DIR)/main.o

# ==== Default target ====
all: $(TARGET)

# ==== Linking ====
$(TARGET): $(OBJ)
	$(CXX) $(CXXFLAGS) $^ -o $@

# ==== Compilation ====
$(BUILD_DIR)/main.o: $(SRC)
	mkdir -p $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# ==== Clean ====
clean:
	rm -rf $(BUILD_DIR) $(TARGET)

# ==== Rebuild ====
rebuild: clean all

.PHONY: all clean rebuild