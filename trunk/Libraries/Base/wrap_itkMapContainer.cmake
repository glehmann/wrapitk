WRAP_INCLUDE("set")

WRAP_CLASS("itk::MapContainer" POINTER)
  foreach(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_UL}${ITKM_VD${d}}"    "${ITKT_UL},${ITKT_VD${d}}")
    WRAP_TEMPLATE("${ITKM_UL}${ITKM_PD${d}}"    "${ITKT_UL},${ITKT_PD${d}}")
  endforeach(d)
  WRAP_TEMPLATE("${ITKM_UL}${ITKM_D}"    "${ITKT_UL},${ITKT_D}")
  WRAP_TEMPLATE("${ITKM_UL}SUL"    "${ITKT_UL}, std::set< unsigned long >")
END_WRAP_CLASS()
