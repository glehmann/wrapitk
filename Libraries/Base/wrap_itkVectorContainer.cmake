WRAP_CLASS("itk::VectorContainer" POINTER)
  FOREACH(d ${WRAP_ITK_DIMS})
    FOREACH(t ${WRAP_ITK_SCALAR})
      WRAP_TEMPLATE("${ITKM_UI}${ITKM_LSN${t}${d}}"  "${ITKT_UI},${ITKT_LSN${t}${d}}")
    ENDFOREACH(t)
    
    WRAP_TEMPLATE("${ITKM_UL}${ITKM_VD${d}}"    "${ITKT_UL},${ITKT_VD${d}}")
    WRAP_TEMPLATE("${ITKM_UL}${ITKM_PD${d}}"    "${ITKT_UL},${ITKT_PD${d}}")
  ENDFOREACH(d)
  WRAP_TEMPLATE("${ITKM_UL}${ITKM_D}"    "${ITKT_UL},${ITKT_D}")
  # used in FastMarchingExtensionImageFilter
  WRAP_TEMPLATE("${ITKM_UI}${ITKM_VUC1}"    "${ITKT_UI},${ITKT_VUC1}")
END_WRAP_CLASS()