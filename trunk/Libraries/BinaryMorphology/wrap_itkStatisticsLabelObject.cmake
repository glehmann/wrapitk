WRAP_CLASS("itk::StatisticsLabelObject" POINTER)
  foreach(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_UL}${d}" "${ITKT_UL},${d}")
  endforeach(d)
END_WRAP_CLASS()