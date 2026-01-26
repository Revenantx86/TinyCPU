# ==========================================
#  8-Bit CPU Project - Test Automation
# ==========================================

# Tools
CC = iverilog
RUN = vvp
FLAGS = -g2012  # Enable SystemVerilog features (needed for our testbenches)

# Directories
SRC = src
TB = test
BUILD = build

# Ensure build directory exists
$(shell mkdir -p $(BUILD))

# ==========================================
#  Default Target: Help
# ==========================================
help:
	@echo "----------------------------------------------------------------"
	@echo "Available Commands:"
	@echo "  make test_alu      -> Test the ALU"
	@echo "  make test_regfile  -> Test the Register File"
	@echo "  make test_pc       -> Test the Program Counter"
	@echo "  make test_mem      -> Test Instruction Memory"
	@echo "  make test_control  -> Test the Control Unit"
	@echo ""
	@echo "  make test_all      -> Run ALL tests"
	@echo "  make clean         -> Remove simulation files"
	@echo "----------------------------------------------------------------"

# ==========================================
#  Individual Unit Tests
# ==========================================

# 1. ALU
test_alu:
	@echo "\n[Compiling ALU...]"
	$(CC) $(FLAGS) -o $(BUILD)/alu_sim $(SRC)/alu.v $(TB)/tb_alu.v
	@echo "[Running ALU Test...]"
	$(RUN) $(BUILD)/alu_sim

# 2. Register File
test_regfile:
	@echo "\n[Compiling Register File...]"
	$(CC) $(FLAGS) -o $(BUILD)/regfile_sim $(SRC)/regfile.v $(TB)/tb_regfile.v
	@echo "[Running Register File Test...]"
	$(RUN) $(BUILD)/regfile_sim

# 3. Program Counter
test_pc:
	@echo "\n[Compiling PC...]"
	$(CC) $(FLAGS) -o $(BUILD)/pc_sim $(SRC)/pc.v $(TB)/tb_pc.v
	@echo "[Running PC Test...]"
	$(RUN) $(BUILD)/pc_sim

# 4. Instruction Memory
test_mem:
	@echo "\n[Compiling Instruction Memory...]"
	$(CC) $(FLAGS) -o $(BUILD)/mem_sim $(SRC)/inst_mem.v $(TB)/tb_inst_mem.v
	@echo "[Running Memory Test...]"
	$(RUN) $(BUILD)/mem_sim

# 5. Control Unit
test_control:
	@echo "\n[Compiling Control Unit...]"
	$(CC) $(FLAGS) -o $(BUILD)/control_sim $(SRC)/control_unit.v $(TB)/tb_control_unit.v
	@echo "[Running Control Unit Test...]"
	$(RUN) $(BUILD)/control_sim

# ==========================================
#  Group Commands
# ==========================================

test_all: test_alu test_regfile test_pc test_mem test_control
	@echo "\n========================================"
	@echo "🎉 ALL TESTS COMPLETE"
	@echo "========================================"

clean:
	rm -rf $(BUILD)
	rm -f program.hex