WRAP_CLASS("itk::QuadEdgeMeshTraits")
  foreach(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("D${d}BBFF" "double, ${d}, bool, bool, float, float")
  endforeach(d)
END_WRAP_CLASS()