###############################################################################
#
# Find PPLite headers and libraries.
#
# Author: Enea Zaffanella
#
# Contact: enea.zaffanella@unipr.it
#
# Notices:
#
# Copyright (c) 2018-2019 United States Government as represented by the
# Administrator of the National Aeronautics and Space Administration.
# All Rights Reserved.
#
# Disclaimers:
#
# No Warranty: THE SUBJECT SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY WARRANTY OF
# ANY KIND, EITHER EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING, BUT NOT LIMITED
# TO, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL CONFORM TO SPECIFICATIONS,
# ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
# OR FREEDOM FROM INFRINGEMENT, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL BE
# ERROR FREE, OR ANY WARRANTY THAT DOCUMENTATION, IF PROVIDED, WILL CONFORM TO
# THE SUBJECT SOFTWARE. THIS AGREEMENT DOES NOT, IN ANY MANNER, CONSTITUTE AN
# ENDORSEMENT BY GOVERNMENT AGENCY OR ANY PRIOR RECIPIENT OF ANY RESULTS,
# RESULTING DESIGNS, HARDWARE, SOFTWARE PRODUCTS OR ANY OTHER APPLICATIONS
# RESULTING FROM USE OF THE SUBJECT SOFTWARE.  FURTHER, GOVERNMENT AGENCY
# DISCLAIMS ALL WARRANTIES AND LIABILITIES REGARDING THIRD-PARTY SOFTWARE,
# IF PRESENT IN THE ORIGINAL SOFTWARE, AND DISTRIBUTES IT "AS IS."
#
# Waiver and Indemnity:  RECIPIENT AGREES TO WAIVE ANY AND ALL CLAIMS AGAINST
# THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS, AS WELL
# AS ANY PRIOR RECIPIENT.  IF RECIPIENT'S USE OF THE SUBJECT SOFTWARE RESULTS
# IN ANY LIABILITIES, DEMANDS, DAMAGES, EXPENSES OR LOSSES ARISING FROM SUCH
# USE, INCLUDING ANY DAMAGES FROM PRODUCTS BASED ON, OR RESULTING FROM,
# RECIPIENT'S USE OF THE SUBJECT SOFTWARE, RECIPIENT SHALL INDEMNIFY AND HOLD
# HARMLESS THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS,
# AS WELL AS ANY PRIOR RECIPIENT, TO THE EXTENT PERMITTED BY LAW.
# RECIPIENT'S SOLE REMEDY FOR ANY SUCH MATTER SHALL BE THE IMMEDIATE,
# UNILATERAL TERMINATION OF THIS AGREEMENT.
#
###############################################################################

if (NOT PPLITE_FOUND)
  set(PPLITE_ROOT "" CACHE PATH "Path to PPLite install directory")

  set(PPLITE_INCLUDE_SEARCH_DIRS "")
  set(PPLITE_LIB_SEARCH_DIRS "")

  if (PPLITE_ROOT)
    list(APPEND PPLITE_INCLUDE_SEARCH_DIRS "${PPLITE_ROOT}/include/")
    list(APPEND PPLITE_LIB_SEARCH_DIRS "${PPLITE_ROOT}/lib")
  endif()

  find_package(GMP REQUIRED)
  find_package(FLINT REQUIRED)
  find_package(APRON REQUIRED)

  find_path(PPLITE_INCLUDE_DIR
    NAMES pplite/pplite.hh
    HINTS ${PPLITE_INCLUDE_SEARCH_DIRS}
    DOC "Path to PPLite include directory"
  )

  find_library(PPLITE_LIB
    NAMES pplite
    HINTS ${PPLITE_LIB_SEARCH_DIRS}
    DOC "Path to PPLite library"
  )

  find_path(AP_PPLITE_INCLUDE_DIR
    NAMES ap_pplite.h
    HINTS ${PPLITE_INCLUDE_SEARCH_DIRS}
    DOC "Path to Apron PPLite's wrapper include directory"
  )

  find_library(AP_PPLITE_LIB
    NAMES ap_pplite
    HINTS ${PPLITE_LIB_SEARCH_DIRS}
    DOC "Path to Apron PPLite's wrapper library ap_pplite"
  )

  if (PPLITE_INCLUDE_DIR AND PPLITE_LIB AND FLINT_FOUND AND GMP_FOUND)
    file(WRITE "${PROJECT_BINARY_DIR}/RunPPLite.cc" "
      #include <ap_pplite.h>
      #include <cassert>

      int main() {
        ap_manager_t* man = ap_pplite_poly_manager_alloc(false);
        ap_abstract0_t* ph = ap_abstract0_bottom(man, 1, 0);
        assert(ap_abstract0_is_bottom(man, ph));
        assert(ap_abstract0_dimension(man, ph).intdim == 1);
        assert(ap_abstract0_dimension(man, ph).realdim == 0);
        return 0;
      }
    ")

    try_run(
      RUN_RESULT
      COMPILE_RESULT
      "${PROJECT_BINARY_DIR}"
      "${PROJECT_BINARY_DIR}/RunPPLite.cc"
      CMAKE_FLAGS
        "-DINCLUDE_DIRECTORIES:STRING=${APRON_INCLUDE_DIRS};${AP_PPLITE_INCLUDE_DIR};${PPLITE_INCLUDE_DIR};${FLINT_INCLUDE_DIR};${GMP_INCLUDE_DIR}"
        "-DLINK_LIBRARIES:STRING=${APRON_LIBRARIES};${AP_PPLITE_LIB};${PPLITE_LIB};${FLINT_LIB};${GMP_LIB}"
      COMPILE_OUTPUT_VARIABLE COMPILE_OUTPUT
    )

    if (NOT COMPILE_RESULT)
      message(FATAL_ERROR "error when trying to compile a program with PPLite:\n${COMPILE_OUTPUT}")
    endif()
    if (RUN_RESULT)
      message(FATAL_ERROR "error when running a program linked with PPLite\n")
    endif()
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(PPLITE
    REQUIRED_VARS
      PPLITE_INCLUDE_DIR
      PPLITE_LIB
      AP_PPLITE_INCLUDE_DIR
      AP_PPLITE_LIB
      FLINT_FOUND
      GMP_FOUND
    FAIL_MESSAGE
      "Could NOT find PPLite. Please provide -DPPLITE_ROOT=/path/to/pplite")
endif()

set(PPLITE_INCLUDE_DIRS
  ${AP_PPLITE_INCLUDE_DIR}
  ${PPLITE_INCLUDE_DIR}
  ${FLINT_INCLUDE_DIR}
  ${GMP_INCLUDE_DIR})

set(PPLITE_LIBRARIES
  ${AP_PPLITE_LIB}
  ${PPLITE_LIB}
  ${FLINT_LIB}
  ${GMP_LIB})
