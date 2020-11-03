/*******************************************************************************
 *
 * \file
 * \brief Implement
 * make_(top|bottom)_machine_int_var_pack_apron_pplite_polyhedra
 *
 * Author: Enea Zaffanella
 *
 * Contact: enea,zaffanella@unipr.it
 *
 * Notices:
 *
 * Copyright (c) 2018-2019 United States Government as represented by the
 * Administrator of the National Aeronautics and Space Administration.
 * All Rights Reserved.
 *
 * Disclaimers:
 *
 * No Warranty: THE SUBJECT SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY WARRANTY OF
 * ANY KIND, EITHER EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING, BUT NOT LIMITED
 * TO, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL CONFORM TO SPECIFICATIONS,
 * ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
 * OR FREEDOM FROM INFRINGEMENT, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL BE
 * ERROR FREE, OR ANY WARRANTY THAT DOCUMENTATION, IF PROVIDED, WILL CONFORM TO
 * THE SUBJECT SOFTWARE. THIS AGREEMENT DOES NOT, IN ANY MANNER, CONSTITUTE AN
 * ENDORSEMENT BY GOVERNMENT AGENCY OR ANY PRIOR RECIPIENT OF ANY RESULTS,
 * RESULTING DESIGNS, HARDWARE, SOFTWARE PRODUCTS OR ANY OTHER APPLICATIONS
 * RESULTING FROM USE OF THE SUBJECT SOFTWARE.  FURTHER, GOVERNMENT AGENCY
 * DISCLAIMS ALL WARRANTIES AND LIABILITIES REGARDING THIRD-PARTY SOFTWARE,
 * IF PRESENT IN THE ORIGINAL SOFTWARE, AND DISTRIBUTES IT "AS IS."
 *
 * Waiver and Indemnity:  RECIPIENT AGREES TO WAIVE ANY AND ALL CLAIMS AGAINST
 * THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS, AS WELL
 * AS ANY PRIOR RECIPIENT.  IF RECIPIENT'S USE OF THE SUBJECT SOFTWARE RESULTS
 * IN ANY LIABILITIES, DEMANDS, DAMAGES, EXPENSES OR LOSSES ARISING FROM SUCH
 * USE, INCLUDING ANY DAMAGES FROM PRODUCTS BASED ON, OR RESULTING FROM,
 * RECIPIENT'S USE OF THE SUBJECT SOFTWARE, RECIPIENT SHALL INDEMNIFY AND HOLD
 * HARMLESS THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS,
 * AS WELL AS ANY PRIOR RECIPIENT, TO THE EXTENT PERMITTED BY LAW.
 * RECIPIENT'S SOLE REMEDY FOR ANY SUCH MATTER SHALL BE THE IMMEDIATE,
 * UNILATERAL TERMINATION OF THIS AGREEMENT.
 *
 ******************************************************************************/

#ifdef HAS_PPLITE

#include <ikos/core/domain/machine_int/numeric_domain_adapter.hpp>
#include <ikos/core/domain/numeric/apron.hpp>
#include <ikos/core/domain/numeric/var_packing_domain.hpp>

#include <ikos/analyzer/analysis/value/machine_int_domain.hpp>
#include <ikos/analyzer/exception.hpp>

namespace ikos {
namespace analyzer {
namespace value {

namespace {

using RND_Poly = core::numeric::VarPackingDomain<
    ZNumber,
    Variable*,
    core::numeric::ApronDomain< core::numeric::apron::PplitePoly,
                                ZNumber,
                                Variable* > >;
using RMID_Poly =
    core::machine_int::NumericDomainAdapter< Variable*, RND_Poly >;

using RND_FPoly = core::numeric::VarPackingDomain<
    ZNumber,
    Variable*,
    core::numeric::ApronDomain< core::numeric::apron::PpliteFPoly,
                                ZNumber,
                                Variable* > >;
using RMID_FPoly =
    core::machine_int::NumericDomainAdapter< Variable*, RND_FPoly >;

using RND_UPoly = core::numeric::VarPackingDomain<
    ZNumber,
    Variable*,
    core::numeric::ApronDomain< core::numeric::apron::PpliteUPoly,
                                ZNumber,
                                Variable* > >;
using RMID_UPoly =
    core::machine_int::NumericDomainAdapter< Variable*, RND_UPoly >;

using RND_UFPoly = core::numeric::VarPackingDomain<
    ZNumber,
    Variable*,
    core::numeric::ApronDomain< core::numeric::apron::PpliteUFPoly,
                                ZNumber,
                                Variable* > >;
using RMID_UFPoly =
    core::machine_int::NumericDomainAdapter< Variable*, RND_UFPoly >;

} // end anonymous namespace

MachineIntAbstractDomain
make_top_machine_int_var_pack_apron_pplite_poly() {
  return MachineIntAbstractDomain(RMID_Poly(RND_Poly::top()));
}
MachineIntAbstractDomain
make_bottom_machine_int_var_pack_apron_pplite_poly() {
  return MachineIntAbstractDomain(RMID_Poly(RND_Poly::bottom()));
}

MachineIntAbstractDomain
make_top_machine_int_var_pack_apron_pplite_fpoly() {
  return MachineIntAbstractDomain(RMID_FPoly(RND_FPoly::top()));
}
MachineIntAbstractDomain
make_bottom_machine_int_var_pack_apron_pplite_fpoly() {
  return MachineIntAbstractDomain(RMID_FPoly(RND_FPoly::bottom()));
}

MachineIntAbstractDomain
make_top_machine_int_var_pack_apron_pplite_upoly() {
  return MachineIntAbstractDomain(RMID_UPoly(RND_UPoly::top()));
}
MachineIntAbstractDomain
make_bottom_machine_int_var_pack_apron_pplite_upoly() {
  return MachineIntAbstractDomain(RMID_UPoly(RND_UPoly::bottom()));
}

MachineIntAbstractDomain
make_top_machine_int_var_pack_apron_pplite_ufpoly() {
  return MachineIntAbstractDomain(RMID_UFPoly(RND_UFPoly::top()));
}
MachineIntAbstractDomain
make_bottom_machine_int_var_pack_apron_pplite_ufpoly() {
  return MachineIntAbstractDomain(RMID_UFPoly(RND_UFPoly::bottom()));
}

} // end namespace value
} // end namespace analyzer
} // end namespace ikos

#endif
