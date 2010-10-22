WRAP_INCLUDE("itkGeometricalQuadEdge.h")
WRAP_INCLUDE("itkQuadEdgeMeshPoint.h")
WRAP_INCLUDE("itkMesh.h")
WRAP_INCLUDE("itkQuadEdgeMeshTraits.h")

WRAP_CLASS("itk::MapContainer" POINTER)
  foreach(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("ULQEMPF${d}" "unsigned long, itk::QuadEdgeMeshPoint< float, ${d} >")
#     WRAP_TEMPLATE("MD${d}QBAIUL" "itk::Mesh<double, ${d}u, itk::QuadEdgeMeshTraits<double, ${d}, bool, bool, float, float> >::BoundaryAssignmentIdentifier, unsigned long")
    WRAP_TEMPLATE("ULCIDQEMCTI${d}" "unsigned long, itk::CellInterface< double, itk::QuadEdgeMeshCellTraitsInfo< ${d} > >*")
  endforeach(d)
END_WRAP_CLASS()

WRAP_CLASS("itk::BoundingBox" POINTER)
  foreach(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("UL${d}FMCULQEMPF${d}" "unsigned long, ${d}, float, itk::MapContainer< unsigned long, itk::QuadEdgeMeshPoint< float, ${d} > >")
  endforeach(d)
END_WRAP_CLASS()