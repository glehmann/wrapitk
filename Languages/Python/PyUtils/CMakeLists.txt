###############################################################################
# Add the ITKPythonSupport library which contains the itkPyCommand class.

WRAP_LIBRARY("ITKPyUtils" Python)

  set(WRAPPER_LIBRARY_DEPENDS Base)
  set(WRAPPER_LIBRARY_LINK_LIBRARIES ITKCommon)

  set(WRAPPER_LIBRARY_CXX_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/itkPyCommand.cxx")

  AUTO_INCLUDE_MODULES()
END_WRAP_LIBRARY()
