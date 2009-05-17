
SET(WRAPPER_AUTO_INCLUDE_HEADERS OFF)
WRAP_INCLUDE("itkNumericTraits.h")
WRAP_INCLUDE("itkNumericTraitsRGBPixel.h")
WRAP_INCLUDE("itkNumericTraitsRGBAPixel.h")
WRAP_INCLUDE("itkNumericTraitsTensorPixel.h")
WRAP_INCLUDE("itkNumericTraitsVariableLengthVectorPixel.h")
WRAP_INCLUDE("itkNumericTraitsFixedArrayPixel.h")
WRAP_INCLUDE("itkNumericTraitsVectorPixel.h")
WRAP_INCLUDE("itkNumericTraitsCovariantVectorPixel.h")

IF(WIN32)
  WRAP_NON_TEMPLATE_CLASS("std::_Num_base" FORCE_INSTANTIATE)
   WRAP_NON_TEMPLATE_CLASS("std::_Num_int_base" FORCE_INSTANTIATE)
  WRAP_NON_TEMPLATE_CLASS("std::_Num_float_base" FORCE_INSTANTIATE)
ENDIF(WIN32)
 
# the superclass
WRAP_CLASS(vcl_numeric_limits FORCE_INSTANTIATE)
  # the basic types
  FOREACH(t UC US UI UL SC SS SI SL F D LD B)
    WRAP_TEMPLATE("${ITKM_${t}}" "${ITKT_${t}}")
  ENDFOREACH(t)
END_WRAP_CLASS()


WRAP_CLASS("itk::NumericTraits")
  # the basic types
  FOREACH(t UC US UI UL SC SS SI SL F D LD B)
    WRAP_TEMPLATE("${ITKM_${t}}" "${ITKT_${t}}")
  ENDFOREACH(t)
  
#  FOREACH(t ${WRAP_ITK_COMPLEX_REAL})
#    WRAP_TEMPLATE("${ITKM_${t}}" "${ITKT_${t}}")
#  ENDFOREACH(t)

  # the ITK types
  
  # rgb, rgba
  UNIQUE(rgbs "RGBUC;RGBAUC;RGBAF;${WRAP_ITK_RGB};${WRAP_ITK_RGBA}")
  FOREACH(t ${WRAP_ITK_RGB} ${WRAP_ITK_RGBA})
    WRAP_TEMPLATE("${ITKM_${t}}" "${ITKT_${t}}")
  ENDFOREACH(t)

  # covariant vector
  FOREACH(d ${WRAP_ITK_DIMS})
    FOREACH(t ${WRAP_ITK_COV_VECTOR_REAL})
      WRAP_TEMPLATE("${ITKM_${t}${d}}" "${ITKT_${t}${d}}")
    ENDFOREACH(t)
  ENDFOREACH(d)
  
  # vector, as in WrapITKTypes.cmake
  UNIQUE(vector_sizes "1;${WRAP_ITK_DIMS};6")
  UNIQUE(vector_types "UC;F;D;${WRAP_ITK_SCALAR}")
  FOREACH(d ${vector_sizes})
    FOREACH(t ${vector_types})
      ADD_TEMPLATE("${ITKM_V${t}${d}}" "${ITKT_V${t}${d}}")
    ENDFOREACH(t)
  ENDFOREACH(d)

  # fixed array, as in WrapITKTypes.cmake
  SET(dims ${WRAP_ITK_DIMS})
  FOREACH(d ${WRAP_ITK_DIMS})
    MATH(EXPR d2 "${d} * 2")
    # for itk::SymmetricSecondRankTensor
    MATH(EXPR d3 "${d} * (${d} + 1) / 2")
    SET(dims ${dims} ${d2} ${d3})
  ENDFOREACH(d)
  UNIQUE(array_sizes "${dims};1;3;4;6")
  # make sure that 1-D FixedArrays are wrapped. Also wrap for each selected
  # image dimension.
  # 3-D FixedArrays are required as superclass of rgb pixels
  # TODO: Do we need fixed arrays for all of these types? For just the selected
  # pixel types plus some few basic cases? Or just for a basic set of types?
  FOREACH(d ${array_sizes})
    ADD_TEMPLATE("${ITKM_FAD${d}}"  "${ITKT_FAD${d}}")
    ADD_TEMPLATE("${ITKM_FAF${d}}"  "${ITKT_FAF${d}}")
    ADD_TEMPLATE("${ITKM_FAUL${d}}" "${ITKT_FAUL${d}}")
    ADD_TEMPLATE("${ITKM_FAUS${d}}" "${ITKT_FAUS${d}}")
    ADD_TEMPLATE("${ITKM_FAUC${d}}" "${ITKT_FAUC${d}}")
    ADD_TEMPLATE("${ITKM_FAUI${d}}" "${ITKT_FAUI${d}}")
    ADD_TEMPLATE("${ITKM_FASL${d}}" "${ITKT_FASL${d}}")
    ADD_TEMPLATE("${ITKM_FASS${d}}" "${ITKT_FASS${d}}")
    ADD_TEMPLATE("${ITKM_FASC${d}}" "${ITKT_FASC${d}}")
    # this one is not defined in itkNumerictTraitsFixedArrayPixel.h
    # ADD_TEMPLATE("${ITKM_FAB${d}}"  "${ITKT_FAB${d}}")
  ENDFOREACH(d)

  # variable length vector, as in WrapITKTypes.cmake
  UNIQUE(wrap_image_types "${WRAP_ITK_SCALAR};UC")
  FOREACH(type ${wrap_image_types})
    ADD_TEMPLATE("${ITKM_VLV${type}}"  "${ITKT_VLV${type}}")
  ENDFOREACH(type)

END_WRAP_CLASS()
