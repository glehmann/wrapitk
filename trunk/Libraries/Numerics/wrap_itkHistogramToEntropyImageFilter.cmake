WRAP_CLASS("itk::HistogramToEntropyImageFilter" POINTER_WITH_SUPERCLASS)
  FOREACH(d ${WRAP_ITK_DIMS})
    FOREACH(t ${WRAP_ITK_REAL})
      WRAP_TEMPLATE("${ITKM_HF${d}}${ITKM_${t}}"  "${ITKT_HF${d}}, ${ITKT_${t}}")
      WRAP_TEMPLATE("${ITKM_HD${d}}${ITKM_${t}}"  "${ITKT_HD${d}}, ${ITKT_${t}}")
    ENDFOREACH(t)
  ENDFOREACH(d)
END_WRAP_CLASS()
