#!/bin/bash 

fail () { 
 echo Execution aborted. 
 read -n1 -r -p "Press any key to continue..." key 
 exit 1 
}

# "name" and "dirout" are named according to the testcase

export name=DamBreakerBoulder
export dirout=${name}_out
export diroutdata=${dirout}/data

# "executables" are renamed and called from their directory

export dirbin=${DUALSPH_HOME}/bin/linux
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${dirbin}
export gencase="${dirbin}/GenCase_linux64"
export dualsphysicscpu="${dirbin}/DualSPHysics5.0CPU_linux64"
export dualsphysicsgpu="${dirbin}/DualSPHysics5.0_linux64"
export boundaryvtk="${dirbin}/BoundaryVTK_linux64"
export partvtk="${dirbin}/PartVTK_linux64"
export partvtkout="${dirbin}/PartVTKOut_linux64"
export measuretool="${dirbin}/MeasureTool_linux64"
export computeforces="${dirbin}/ComputeForces_linux64"
export isosurface="${dirbin}/IsoSurface_linux64"
export flowtool="${dirbin}/FlowTool_linux64"
export floatinginfo="${dirbin}/FloatingInfo_linux64"


export dirout2=${dirout}/particles
# ${partvtk} -dirin ${diroutdata} -savevtk ${dirout2}/PartFluid -onlytype:-all,+fluid
# ${partvtk} -dirin ${diroutdata} -continue:1 -savevtk ${dirout2}/PartFluid -onlytype:-all,+fluid
# if [ $? -ne 0 ] ; then fail; fi

${partvtk} -dirin ${diroutdata} -savevtk ${dirout2}/PartBoulder -onlytype:-all,+floating
if [ $? -ne 0 ] ; then fail; fi

export dirout2=${dirout}/boundary
${boundaryvtk} -loadvtk AutoDp -motiondata ${diroutdata} -savevtkdata ${dirout2}/Boulder -onlytype:floating -savevtkdata ${dirout2}/Boulder.vtk -onlytype:fixed
if [ $? -ne 0 ] ; then fail; fi

export dirout2=${dirout}/floatinginfo
${floatinginfo} -dirin ${diroutdata} -onlymk:61 -savedata ${dirout2}/FloatingMotion 
if [ $? -ne 0 ] ; then fail; fi

export dirout2=${dirout}/surface
${isosurface} -dirin ${diroutdata} -saveiso ${dirout2}/Surface
if [ $? -ne 0 ] ; then fail; fi

read -n1 -r -p "Press any key to continue..." key
