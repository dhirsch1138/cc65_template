#copied from https://github.com/dbuchwald/cc65-tools
#include common/tools.mk
#because we hid the common directory for make in .c65
include $(COMMON_FOLDER)tools.mk

#TODO BUILD&TEMP
BUILD_FOLDER=../build
TEMP_FOLDER=$(BUILD_FOLDER)/$(ROM_NAME)
ROM_FILE=$(BUILD_FOLDER)/$(ROM_NAME).bin
LST_FILE=$(TEMP_FOLDER)/$(ROM_NAME).lst

# Link ROM image
$(ROM_FILE): $(AASM_SOURCEFILENAMESM_SOURCES)
	@$(MKDIR_BINARY) $(MKDIR_FLAGS) $(BUILD_FOLDER)
	@$(MKDIR_BINARY) $(MKDIR_FLAGS) $(TEMP_FOLDER)
	$(VASM_BINARY) $(VASM_FLAGS) -o $@ -L $(LST_FILE) $(ASM_SOURCES)

# Default target
all: $(ROM_FILE)

# Build and dump output
test: $(ROM_FILE)
	$(HEXDUMP_BINARY) $(HEXDUMP_FLAGS) $<
	$(MD5_BINARY) $<

# Clean build artifacts
clean:
	$(RM_BINARY) -f $(ROM_FILE) \
	$(LST_FILE) 