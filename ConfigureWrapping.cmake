###############################################################################
# ConfigureWrapping.cmake
#
# This file sets up all needed macros, paths, and so forth for wrapping itk
# projects.
#
# The following variables should be set before including this file:
# WRAP_ITK_TCL
# WRAP_ITK_PYTHON
# WRAP_ITK_JAVA
# WRAP_unsigned_char
# WRAP_unsigned_short
# WRAP_unsigned_long
# WRAP_signed_char
# WRAP_signed_short
# WRAP_signed_long
# WRAP_float
# WRAP_double
# WRAP_vector_float
# WRAP_vector_double
# WRAP_covariant_vector_float
# WRAP_covariant_vector_double
# WRAP_ITK_DIMS
# WRAP_ITK_JAVA_DIR -- directory for java classes to be placed
# WRAP_ITK_CONFIG_DIR -- directory where XXX.in files for CONFIGURE_FILE
#                        commands are to be found.
# WRAP_ITK_CMAKE_DIR -- directory where XXX.cmake files are to be found
#
# This file sets a default value for WRAPPER_MASTER_INDEX_OUTPUT_DIR and
# WRAPPER_SWIG_LIBRARY_OUTPUT_DIR. Change it after including this file if needed,
# but this shouldn't really be necessary except for complex external projects.
#
# A note on convention: Global variables (those shared between macros) are
# defined in ALL_CAPS (or partially all-caps, for the WRAP_pixel_type) values
# listed above. Variables local to a macro are in lower-case.
# Moreover, only variables defined in this file (or listed) above are shared
# across macros defined in different files. All other global variables are
# only used by the macros defined in a given cmake file.
###############################################################################

cmake_minimum_required(VERSION 2.4.2 FATAL_ERROR)


###############################################################################
# Find Required Packages
###############################################################################

#-----------------------------------------------------------------------------
# Find ITK
#-----------------------------------------------------------------------------
find_package(ITK REQUIRED)
include(${ITK_USE_FILE})
# we must be sure we have the right ITK version; WrapITK can't build with
# an old version of ITK because some classes will not be there.
# newer version should only cause some warnings
set(ITK_REQUIRED_VERSION "3.11.0")
set(ITK_VERSION "${ITK_VERSION_MAJOR}.${ITK_VERSION_MINOR}.${ITK_VERSION_PATCH}")
if("${ITK_VERSION}" STRLESS "${ITK_REQUIRED_VERSION}")
  message(FATAL_ERROR "ITK ${ITK_REQUIRED_VERSION} is required to build this version of WrapITK, and you are trying to use version ${ITK_VERSION}. Set ITK_DIR to point to the directory of ITK ${ITK_REQUIRED_VERSION}.")
endif("${ITK_VERSION}" STRLESS "${ITK_REQUIRED_VERSION}")

set(CMAKE_VERSION "${CMAKE_CACHE_MAJOR_VERSION}.${CMAKE_CACHE_MINOR_VERSION}.${CMAKE_CACHE_RELEASE_VERSION}")
if("${CMAKE_VERSION}" STRGREATER "2.6")
  cmake_policy(SET CMP0003 NEW)
endif("${CMAKE_VERSION}" STRGREATER "2.6")

###############################################################################
# Set various variables in order
###############################################################################
# set(CMAKE_SKIP_RPATH ON CACHE BOOL "ITK wrappers must not have runtime path information." FORCE)

#------------------------------------------------------------------------------
# System dependant wraping stuff

# Make a variable that expands to nothing if there are no configuration types,
# otherwise it expands to the active type plus a /, so that in either case,
# the variable can be used in the middle of a path.
if(CMAKE_CONFIGURATION_TYPES)
  set(WRAP_ITK_BUILD_INTDIR "${CMAKE_CFG_INTDIR}/")
  set(WRAP_ITK_INSTALL_INTDIR "\${BUILD_TYPE}/")

  # horrible hack to avoid having ${BUILD_TYPE} expanded to an empty sting
  # while passing through the macros.
  # Insitead of expanding to an empty string, it expand to ${BUILD_TYPE}
  # and so can be reexpanded again and again (and again)
  set(BUILD_TYPE "\${BUILD_TYPE}")

else(CMAKE_CONFIGURATION_TYPES)
  set(WRAP_ITK_BUILD_INTDIR "")
  set(WRAP_ITK_INSTALL_INTDIR "")
endif(CMAKE_CONFIGURATION_TYPES)


set(ITK_WRAP_NEEDS_DEPEND 1)
if(${CMAKE_MAKE_PROGRAM} MATCHES make)
  set(ITK_WRAP_NEEDS_DEPEND 0)
endif(${CMAKE_MAKE_PROGRAM} MATCHES make)

set(CSWIG_DEFAULT_LIB ${CableSwig_DIR}/SWIG/Lib )

set(CSWIG_EXTRA_LINKFLAGS )
if(CMAKE_BUILD_TOOL MATCHES "(msdev|devenv|nmake)")
  set(CSWIG_EXTRA_LINKFLAGS "/IGNORE:4049 /IGNORE:4109")
endif(CMAKE_BUILD_TOOL MATCHES "(msdev|devenv|nmake)")

if(CMAKE_SYSTEM MATCHES "IRIX.*")
  if(CMAKE_CXX_COMPILER MATCHES "CC")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -woff 1552")
  endif(CMAKE_CXX_COMPILER MATCHES "CC")
endif(CMAKE_SYSTEM MATCHES "IRIX.*")

if(CMAKE_COMPILER_IS_GNUCXX)
  string(REGEX REPLACE "-Wcast-qual" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
endif(CMAKE_COMPILER_IS_GNUCXX)

if(UNIX)
  set(WRAP_ITK_LIBNAME_PREFIX "lib")
else(UNIX)
  set(WRAP_ITK_LIBNAME_PREFIX "")
endif(UNIX)

# 467 is for warnings caused by typemap on overloaded methods
set(CSWIG_IGNORE_WARNINGS -w362 -w389 -w467 -w503 -w508 -w509 -w516)
add_definitions(-DSWIG_GLOBAL)

# languages dir
set(LANGUAGES_SRC_DIR "${WRAP_ITK_CMAKE_DIR}/Languages" CACHE INTERNAL "languages source directory")

###############################################################################
# Define install files macro. If we are building WrapITK, the generated files
# and libraries will be installed into CMAKE_INSTALL_PREFIX, as usual. However,
# if we are building an external project, we need to ensure that the wrapper
# files will be installed into wherever WrapITK was installed.
###############################################################################
include("${WRAP_ITK_CMAKE_DIR}/CMakeUtilityFunctions.cmake")

macro(WRAP_ITK_INSTALL path)
  install(FILES ${ARGN} DESTINATION "${WRAP_ITK_INSTALL_PREFIX}${path}")
endmacro(WRAP_ITK_INSTALL)

###############################################################################
# Include needed macros -- WRAP_ITK_CMAKE_DIR must be set correctly
###############################################################################
include("${WRAP_ITK_CMAKE_DIR}/TypedefMacros.cmake")

###############################################################################
# Create wrapper names for simple types to ensure consistent naming
###############################################################################
include("${WRAP_ITK_CMAKE_DIR}/WrapBasicTypes.cmake")
include("${WRAP_ITK_CMAKE_DIR}/WrapITKTypes.cmake")

###############################################################################
# Lets the target languages do their job
###############################################################################
add_subdirectory("${WRAP_ITK_CMAKE_DIR}/Languages" "${CMAKE_CURRENT_BINARY_DIR}/Languages")
# get the porperties from the languages dirs - there should be others than this one
get_directory_property(inc DIRECTORY "${WRAP_ITK_CMAKE_DIR}/Languages" INCLUDE_DIRECTORIES)
include_directories(${inc})
