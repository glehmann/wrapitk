WRAP_CLASS("itk::TubeSpatialObjectPoint")
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${d}" "${d}")
  ENDFOREACH(d)
END_WRAP_CLASS()
