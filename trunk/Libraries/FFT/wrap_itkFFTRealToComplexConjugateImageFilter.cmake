WRAP_CLASS("itk::FFTRealToComplexConjugateImageFilter" POINTER)
  foreach(d ${WRAP_ITK_DIMS})
    if(WRAP_complex_float AND WRAP_float)
      WRAP_TEMPLATE("${ITKM_F}${d}" "${ITKT_F},${d}")
    endif(WRAP_complex_float AND WRAP_float)

    if(WRAP_complex_double AND WRAP_double)
      WRAP_TEMPLATE("${ITKM_D}${d}" "${ITKT_D},${d}")
    endif(WRAP_complex_double AND WRAP_double)
  endforeach(d)
END_WRAP_CLASS()

