#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/light-control-system-please.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/light-control-system-please.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=
else
COMPARISON_BUILD=
endif

ifdef SUB_IMAGE_ADDRESS

else
SUB_IMAGE_ADDRESS_COMMAND=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=LCD.S ACD.s UART.s main.s config.s DAC_Interrupt.s test.s keypad.s

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/LCD.o ${OBJECTDIR}/ACD.o ${OBJECTDIR}/UART.o ${OBJECTDIR}/main.o ${OBJECTDIR}/config.o ${OBJECTDIR}/DAC_Interrupt.o ${OBJECTDIR}/test.o ${OBJECTDIR}/keypad.o
POSSIBLE_DEPFILES=${OBJECTDIR}/LCD.o.d ${OBJECTDIR}/ACD.o.d ${OBJECTDIR}/UART.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/config.o.d ${OBJECTDIR}/DAC_Interrupt.o.d ${OBJECTDIR}/test.o.d ${OBJECTDIR}/keypad.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/LCD.o ${OBJECTDIR}/ACD.o ${OBJECTDIR}/UART.o ${OBJECTDIR}/main.o ${OBJECTDIR}/config.o ${OBJECTDIR}/DAC_Interrupt.o ${OBJECTDIR}/test.o ${OBJECTDIR}/keypad.o

# Source Files
SOURCEFILES=LCD.S ACD.s UART.s main.s config.s DAC_Interrupt.s test.s keypad.s



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/light-control-system-please.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=PIC18F87K22
# ------------------------------------------------------------------------------------
# Rules for buildStep: pic-as-assembler
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/LCD.o: LCD.S  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/LCD.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/LCD.o \
	LCD.S \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/ACD.o: ACD.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/ACD.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/ACD.o \
	ACD.s \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/UART.o: UART.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/UART.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/UART.o \
	UART.s \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/main.o: main.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/main.o \
	main.s \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/config.o: config.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/config.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/config.o \
	config.s \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/DAC_Interrupt.o: DAC_Interrupt.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/DAC_Interrupt.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/DAC_Interrupt.o \
	DAC_Interrupt.s \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/test.o: test.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/test.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/test.o \
	test.s \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/keypad.o: keypad.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/keypad.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/keypad.o \
	keypad.s \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
else
${OBJECTDIR}/LCD.o: LCD.S  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/LCD.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/LCD.o \
	LCD.S \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/ACD.o: ACD.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/ACD.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/ACD.o \
	ACD.s \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/UART.o: UART.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/UART.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/UART.o \
	UART.s \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/main.o: main.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/main.o \
	main.s \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/config.o: config.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/config.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/config.o \
	config.s \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/DAC_Interrupt.o: DAC_Interrupt.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/DAC_Interrupt.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/DAC_Interrupt.o \
	DAC_Interrupt.s \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/test.o: test.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/test.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/test.o \
	test.s \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
${OBJECTDIR}/keypad.o: keypad.s  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/keypad.o 
	${MP_AS} -mcpu=PIC18F87K22 -c \
	-o ${OBJECTDIR}/keypad.o \
	keypad.s \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: pic-as-linker
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/light-control-system-please.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} -mcpu=PIC18F87K22 ${OBJECTFILES_QUOTED_IF_SPACED} \
	-o dist/${CND_CONF}/${IMAGE_TYPE}/light-control-system-please.${IMAGE_TYPE}.${OUTPUT_SUFFIX} \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -mcallgraph=std -mno-download-hex
else
dist/${CND_CONF}/${IMAGE_TYPE}/light-control-system-please.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} -mcpu=PIC18F87K22 ${OBJECTFILES_QUOTED_IF_SPACED} \
	-o dist/${CND_CONF}/${IMAGE_TYPE}/light-control-system-please.${IMAGE_TYPE}.${OUTPUT_SUFFIX} \
	 -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -mcallgraph=std -mno-download-hex
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
