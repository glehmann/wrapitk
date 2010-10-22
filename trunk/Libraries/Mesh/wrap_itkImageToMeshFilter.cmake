WRAP_INCLUDE("itkMesh.h")
WRAP_INCLUDE("itkQuadEdgeMeshTraits.h")

WRAP_CLASS("itk::ImageToMeshFilter" POINTER)
  foreach(d ${WRAP_ITK_DIMS})
    foreach(t ${WRAP_ITK_INT})
      WRAP_TEMPLATE("${ITKM_I${t}${d}}MD${d}Q" "${ITKT_I${t}${d}}, itk::Mesh< ${ITKT_D},${d},itk::QuadEdgeMeshTraits< ${ITKT_D},${d},${ITKT_B},${ITKT_B},${ITKT_F},${ITKT_F} > >")
    endforeach(t)
  endforeach(d)
END_WRAP_CLASS()
