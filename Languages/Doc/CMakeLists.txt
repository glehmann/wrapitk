FIND_PACKAGE(Doxygen REQUIRED)

###############################################################################
# install the files requires for doxygen
IF(NOT EXTERNAL_WRAP_ITK_PROJECT)
  WRAP_ITK_INSTALL(/Configuration/Languages/Doc CMakeLists.txt)
  WRAP_ITK_INSTALL(/Configuration/Languages/Doc doxygen.config.in)
ENDIF(NOT EXTERNAL_WRAP_ITK_PROJECT)

###############################################################################
# store the current dir, so it can be reused later
SET(WRAP_ITK_DOC_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}" CACHE INTERNAL "doc source dir")
SET(WRAP_ITK_DOC_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}" CACHE INTERNAL "doc binary dir")


###############################################################################
# the var to store the file to be processed by doxygen
SET(WRAP_ITK_DOC_DOXYGEN_HEADERS "" CACHE INTERNAL "doxygen headers to process")

###############################################################################
# the var to store the file produced by doxygen
SET(WRAP_ITK_DOC_DOXYGEN_PAGES "" CACHE INTERNAL "man pages produced by doxygen")


MACRO(WRAP_NAMED_CLASS_DOC class swig_name)
  GET_PROPERTY(dirs DIRECTORY PROPERTY INCLUDE_DIRECTORIES)
  SET(paths )
  FOREACH(dir ${dirs})
    SET(paths ${paths} "${dir}/${swig_name}.h")
  ENDFOREACH(dir)
  FILE(GLOB doc_path ${paths})
  IF(doc_path AND "${class}" MATCHES "^itk::")
    # store the header
    SET(WRAP_ITK_DOC_DOXYGEN_HEADERS ${WRAP_ITK_DOC_DOXYGEN_HEADERS} "${doc_path}" CACHE INTERNAL "doxygen headers to process")
    # and the produced file
    STRING(REPLACE "::" "_" base_name "${class}")
    SET(page "${WRAP_ITK_DOC_BINARY_DIR}/man3/${base_name}.3")
    SET(WRAP_ITK_DOC_DOXYGEN_PAGES "${WRAP_ITK_DOC_DOXYGEN_PAGES};${page}" CACHE INTERNAL "man pages produced by doxygen")
  ENDIF(doc_path AND "${class}" MATCHES "^itk::")
ENDMACRO(WRAP_NAMED_CLASS_DOC)


MACRO(END_WRAP_MODULES_DOC)
  #
  # configure doxygen input file.
  #
  # be sure to not include a header several times
  UNIQUE(headers "${WRAP_ITK_DOC_DOXYGEN_HEADERS}")
  SET(WRAP_ITK_DOC_DOXYGEN_HEADERS_FORMATED)
  FOREACH(header ${headers})
    SET(WRAP_ITK_DOC_DOXYGEN_HEADERS_FORMATED "${WRAP_ITK_DOC_DOXYGEN_HEADERS_FORMATED}           \"${header}\"\\\n")
  ENDFOREACH(header)
  CONFIGURE_FILE("${WRAP_ITK_DOC_SOURCE_DIR}/doxygen.config.in" 
    "${WRAP_ITK_DOC_BINARY_DIR}/doxygen.config"
    @ONLY IMMEDIATE)
  
  #
  # run doxygen
  #
  ADD_CUSTOM_COMMAND(
    OUTPUT ${WRAP_ITK_DOC_DOXYGEN_PAGES}
    COMMAND "${DOXYGEN_EXECUTABLE}" "${WRAP_ITK_DOC_BINARY_DIR}/doxygen.config"
#    WORKING_DIRECTORY ${WRAP_ITK_DOC_BINARY_DIR}
    DEPENDS ${WRAP_ITK_DOC_DOXYGEN_HEADERS}
    COMMENT "Generating manpages."
  )
  ADD_CUSTOM_TARGET(Doxygen ALL DEPENDS ${WRAP_ITK_DOC_DOXYGEN_PAGES})

  #
  # install the produced files
  #
  FOREACH(page ${WRAP_ITK_DOC_DOXYGEN_PAGES})
    WRAP_ITK_INSTALL(/Doc/man3 "${page}")
  ENDFOREACH(page)
  
ENDMACRO(END_WRAP_MODULES_DOC)