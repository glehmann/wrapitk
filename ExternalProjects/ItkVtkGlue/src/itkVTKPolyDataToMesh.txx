#ifndef _itkVTKPolyDataToMesh_txx
#define _itkVTKPolyDataToMesh_txx

#include <iostream>
#include "itkVTKPolyDataToMesh.h"

#ifndef vtkDoubleType
#define vtkDoubleType double
#endif

#ifndef vtkFloatingPointType
# define vtkFloatingPointType vtkFloatingPointType
typedef float vtkFloatingPointType;
#endif

namespace itk
{

template <class TMesh>
VTKPolyDataToMesh <TMesh>
::VTKPolyDataToMesh()
{

  m_itkMesh = TriangleMeshType::New();
  m_PolyData = vtkPolyData::New();

}


template <class TMesh>
VTKPolyDataToMesh <TMesh>
::~VTKPolyDataToMesh()
{
  if (m_PolyData)
    {
      m_PolyData->Delete();
    }
}

template <class TMesh>
void
VTKPolyDataToMesh <TMesh>
::SetInput(vtkPolyData * polydata)
{
  m_PolyData = polydata;
  this->Update();
}

template <class TMesh>
vtkPolyData *
VTKPolyDataToMesh <TMesh>
::GetInput()
{
  return m_PolyData;
}

template <class TMesh>
typename VTKPolyDataToMesh<TMesh>::TriangleMeshType *
VTKPolyDataToMesh <TMesh>
::GetOutput()
{
  return m_itkMesh;
}

template <class TMesh>
void
VTKPolyDataToMesh <TMesh>
::Update()
{
  //
  // Transfer the points from the vtkPolyData into the itk::Mesh
  //
  const unsigned int numberOfPoints = m_PolyData->GetNumberOfPoints();
  vtkPoints * vtkpoints =  m_PolyData->GetPoints();

  m_itkMesh->GetPoints()->Reserve( numberOfPoints );

  for(unsigned int p =0; p < numberOfPoints; p++)
    {

    vtkFloatingPointType * apoint = vtkpoints->GetPoint( p );
    m_itkMesh->SetPoint( p, typename TriangleMeshType::PointType( apoint ));

    // Need to convert the point to PoinType
    typename TriangleMeshType::PointType pt;
    for(unsigned int i=0;i<3; i++)
      {
       pt[i] = apoint[i];
       }
     m_itkMesh->SetPoint( p, pt);

    }
  //
  // Transfer the cells from the vtkPolyData into the itk::Mesh
  //
  vtkCellArray * triangleStrips = m_PolyData->GetStrips();

  vtkIdType  * cellPoints;
  vtkIdType    numberOfCellPoints;

  //
  // First count the total number of triangles from all the triangle strips.
  //
  unsigned int numberOfTriangles = 0;

  triangleStrips->InitTraversal();
  while( triangleStrips->GetNextCell( numberOfCellPoints, cellPoints ) )
    {
    numberOfTriangles += numberOfCellPoints-2;
    }

   vtkCellArray * polygons = m_PolyData->GetPolys();

   polygons->InitTraversal();

   while( polygons->GetNextCell( numberOfCellPoints, cellPoints ) )
     {
     if( numberOfCellPoints == 3 )
       {
        numberOfTriangles ++;
       }
     }

   //
  // Reserve memory in the itk::Mesh for all those triangles
  //
   m_itkMesh->GetCells()->Reserve( numberOfTriangles );

  //
  // Copy the triangles from vtkPolyData into the itk::Mesh
  //
  //

   typedef typename TriangleMeshType::CellType   CellType;

   typedef TriangleCell< CellType > TriangleCellType;

  // first copy the triangle strips
   int cellId = 0;
   triangleStrips->InitTraversal();
   while( triangleStrips->GetNextCell( numberOfCellPoints, cellPoints ) )
     {
     unsigned int numberOfTrianglesInStrip = numberOfCellPoints - 2;

     unsigned long pointIds[3];
     pointIds[0] = cellPoints[0];
     pointIds[1] = cellPoints[1];
     pointIds[2] = cellPoints[2];

     for( unsigned int t=0; t < numberOfTrianglesInStrip; t++ )
       {
        typename TriangleMeshType::CellAutoPointer c;
        TriangleCellType * tcell = new TriangleCellType;
        tcell->SetPointIds( pointIds );
        c.TakeOwnership( tcell );
        m_itkMesh->SetCell( cellId, c );
        cellId++;
        pointIds[0] = pointIds[1];
        pointIds[1] = pointIds[2];
        pointIds[2] = cellPoints[t+3];
       }

     }

   // then copy the triangles
   polygons->InitTraversal();
   while( polygons->GetNextCell( numberOfCellPoints, cellPoints ) )
     {
     if( numberOfCellPoints !=3 ) // skip any non-triangle.
       {
       continue;
       }
     typename TriangleMeshType::CellAutoPointer c;
     TriangleCellType * t = new TriangleCellType;
     t->SetPointIds( (unsigned long*)cellPoints );
     c.TakeOwnership( t );
     m_itkMesh->SetCell( cellId, c );
     cellId++;
     }

}

}

#endif
