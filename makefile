RPI_VERSION ?= 4
#Variable for raspiberry pi version

BOOTMNT ?= /home/uberburst/OS_Build
#boot mount which is where files are copied to after compiling

ARMGNU ?= aarch64-linux-gnu
#name for the cross compiler
#ARMGNU is a corss compiler prefix, we need it becuase we are compiling arm64 on x86, using aarch64-linux-gnu-gcc

COPS = -DRPI_VERSION=$(RPI_VERSION) -Wall -nostdlib -nostartfiles -ffreestanding \
		-Iinclude -mgeneral-regs-only
#C options to send to the crosscompile, no standard libraries, and it will be freestanding, pass include director, use general registers

ASMOPS = -Iinclude
#pass the include path

#these are options that are passedto the compiler when compiling the C and assmebler code respectivly
#-Wall: Show all warnings
#-nostdlib: Do not use the c standard library, most the calls in the c std lib interact with the operating system, since this is
# bare metal, the library isn't going to work
#-nostartfiles: Don't use standard start files. Startup files are responsible for setting up an initial stack pointer, initialzing static data and 
#jumping to the main entry points, we will be doing this manually
#-ffreestanding: A freestanding environment is an environment in which which hte std lib may nto exist and program may not start at main
# this option directs the compiler to assume that std functions have their typical definition
#-Iinclude: search for header files in the include folder
#-mgeneral-regs-only: Use only the general purpose registers. Arm have "NEON" registers (??? Learn more later). We do not 
# want the compiler to use them because they add complexity.

BUILD_DIR = build
SRC_DIR = src
#build and source directory, src_dir and build_dir are directories that contain source and compiled objects files, respectivly
all : kernel8.img
#For all we build the kernel's image
#Two make targets, 
#All: the all target is the default one, it is exectuded whenever you type make without any arguements, this redirects all work to
# A different target (kernel8.img)

clean: 
	rm -rf $(BUILD_DIR) *.img
#We clean out the build directory and clear out image files
#clean: Clean is called to delete all compilation artifacts and the compiled kernel image

$(BUILD_DIR)/%_c.o: $(SRC_DIR)/%.c
	mkdir -p $(@D)
	$(ARMGNU)-gcc $(COPS) -MMD -c $< -o $@


#For all compiled C files, reference c files here, create a build directory if it doesn't exist
#call the armgnu with the c options, and specifi compile only with the output file

$(BUILD_DIR)/%_s.o: $(SRC_DIR)/%.S
	mkdir -p $(@D)
	$(ARMGNU)-gcc $(ASMOPS) -MMD -c $< -o $@
#same for the assembly files
#-p: if it doesn't exist
#@D: is the directorym if $@ doesn't have a slash, then its .
#-MMD: Creates a dependency file for each generated objected file. A dependecy file defiens all of the dependencies for a particular source files
#These dependencies usually contain a list of all included headers

#These two targets are responsible for compiling C and assembler files. If, for example, in the src directory we have foo.c amd foo.S files
#They will be compiled into build/foo_c.o and build/foo_s.o respectively
#$< and $@ are subsituted at runtime with the input and output filenames (foo.c and foo_c.o). Before compiling C files,
#We also create a build directory incase it doesn't exist

#create variables for the files we will be compiling and building
C_FILES = $(wildcard $(SRC_DIR)/*.c)
ASM_FILES = $(wildcard $(SRC_DIR)/*.S)
OBJ_FILES = $(C_FILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%_c.o)
#load object files here, for the files related to the c files
OBJ_FILES += $(ASM_FILES:$(SRC_DIR)/%.S=$(BUILD_DIR)/%_s.o)
#add to that the files related to the assembly files

#* is used to generate a list of matching files in the current directory, * is a wildcard character
#% is a place holder for a file which may or may not exist at the moment

#building an array of all object files that are created from the concatenation of both c and assembler source files


DEP_FILES = $(OBJ_FILES:%.o=%.d)
-include $(DEP_FILES)
#section for dependency files
#We need to include all of the generated dependency files so that make knows what exactly to recompile in case a header changes
#.d are the dependency filess

kernel8.img: $(SRC_DIR)/linker.ld $(OBJ_FILES)
	@echo "Building for RPI $(value RPI_VERSION)"
	@echo "Deploy to $(value BOOTMNT)"
	@echo ""
	$(ARMGNU)-ld -T $(SRC_DIR)/linker.ld -o $(BUILD_DIR)/kernel8.elf $(OBJ_FILES)
	$(ARMGNU)-objcopy $(BUILD_DIR)/kernel8.elf -O binary $(BUILD_DIR)/kernel8.img
ifeq ($(RPI_VERSION),4)
	cp  $(BUILD_DIR)/kernel8.img $(BOOTMNT)/kernel8-rpi4.img
else
	cp kernel8.img $(BOOTMNT)/
endif
	cp config.txt $(BOOTMNT)/
	sync

#$(ARMGNU)-ld~ : USe the OBJ_FILES array to build the kernel8.elf file, we use the linker script src
#$(ARGMNU)-objcopy converts kernel8.elf to raw binary file
