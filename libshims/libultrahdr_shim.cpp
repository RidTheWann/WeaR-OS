//
// SPDX-FileCopyrightText: The LineageOS Project
// SPDX-License-Identifier: Apache-2.0
//

#include <ultrahdr/jpegr.h>

using namespace ultrahdr;

extern "C" status_t
_ZN7android8ultrahdr5JpegR11encodeJPEGREPNS0_25jpegr_uncompressed_structES3_PNS0_23jpegr_compressed_structENS0_26ultrahdr_transfer_functionES5_(
        JpegR* thisptr, jr_uncompressed_ptr p010, jr_uncompressed_ptr yuv420,
        jr_compressed_ptr jpeg, ultrahdr_transfer_function tf, jr_compressed_ptr dest) {
    return thisptr->encodeJPEGR(p010, yuv420, jpeg, tf, dest);
}
