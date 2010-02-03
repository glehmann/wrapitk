WRAP_CLASS("itk::HoughTransform2DCirclesImageFilter" POINTER)
  FILTER_DIMS(d2 2)
  IF(d2)
    FOREACH(t ${WRAP_ITK_REAL})
      WRAP_TEMPLATE("${ITKM_${t}}${ITKM_${t}}" "${ITKT_${t}}, ${ITKT_${t}}")
    ENDFOREACH(t)
  ENDIF(d2)
END_WRAP_CLASS()
