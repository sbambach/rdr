type characteristic =
    | IMAGE_FILE_RELOCS_STRIPPED
    | IMAGE_FILE_EXECUTABLE_IMAGE
    | IMAGE_FILE_LINE_NUMS_STRIPPED
    | IMAGE_FILE_LOCAL_SYMS_STRIPPED
    | IMAGE_FILE_AGGRESSIVE_WS_TRIM
    | IMAGE_FILE_LARGE_ADDRESS_AWARE
    | RESERVED
    | IMAGE_FILE_BYTES_REVERSED_LO
    | IMAGE_FILE_32BIT_MACHINE
    | IMAGE_FILE_DEBUG_STRIPPED
    | IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP
    | IMAGE_FILE_NET_RUN_FROM_SWAP
    | IMAGE_FILE_SYSTEM
    | IMAGE_FILE_DLL
    | IMAGE_FILE_UP_SYSTEM_ONLY
    | IMAGE_FILE_BYTES_REVERSED_HI
    | UNKNOWN of int

let get_characteristic =
  function
  | 0x0001 -> IMAGE_FILE_RELOCS_STRIPPED
  | 0x0002 -> IMAGE_FILE_EXECUTABLE_IMAGE
  | 0x0004 -> IMAGE_FILE_LINE_NUMS_STRIPPED
  | 0x0008 -> IMAGE_FILE_LOCAL_SYMS_STRIPPED
  | 0x0010 -> IMAGE_FILE_AGGRESSIVE_WS_TRIM
  | 0x0020 -> IMAGE_FILE_LARGE_ADDRESS_AWARE
  | 0x0040 -> RESERVED
  | 0x0080 -> IMAGE_FILE_BYTES_REVERSED_LO
  | 0x0100 -> IMAGE_FILE_32BIT_MACHINE
  | 0x0200 -> IMAGE_FILE_DEBUG_STRIPPED
  | 0x0400 -> IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP
  | 0x0800 -> IMAGE_FILE_NET_RUN_FROM_SWAP
  | 0x1000 -> IMAGE_FILE_SYSTEM
  | 0x2000 -> IMAGE_FILE_DLL
  | 0x4000 -> IMAGE_FILE_UP_SYSTEM_ONLY
  | 0x8000 -> IMAGE_FILE_BYTES_REVERSED_HI
  | x -> UNKNOWN x

let characteristic_to_int =
  function
  | IMAGE_FILE_RELOCS_STRIPPED -> 0x0001
  | IMAGE_FILE_EXECUTABLE_IMAGE -> 0x0002
  | IMAGE_FILE_LINE_NUMS_STRIPPED -> 0x0004
  | IMAGE_FILE_LOCAL_SYMS_STRIPPED -> 0x0008
  | IMAGE_FILE_AGGRESSIVE_WS_TRIM -> 0x0010
  | IMAGE_FILE_LARGE_ADDRESS_AWARE -> 0x0020
  | RESERVED -> 0x0040
  | IMAGE_FILE_BYTES_REVERSED_LO -> 0x0080
  | IMAGE_FILE_32BIT_MACHINE -> 0x0100
  | IMAGE_FILE_DEBUG_STRIPPED -> 0x0200
  | IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP -> 0x0400
  | IMAGE_FILE_NET_RUN_FROM_SWAP -> 0x0800
  | IMAGE_FILE_SYSTEM -> 0x1000
  | IMAGE_FILE_DLL -> 0x2000
  | IMAGE_FILE_UP_SYSTEM_ONLY -> 0x4000
  | IMAGE_FILE_BYTES_REVERSED_HI -> 0x8000
  | UNKNOWN x -> x

let characteristic_to_string =
  function
  | IMAGE_FILE_RELOCS_STRIPPED -> "IMAGE_FILE_RELOCS_STRIPPED"
  | IMAGE_FILE_EXECUTABLE_IMAGE -> "IMAGE_FILE_EXECUTABLE_IMAGE"
  | IMAGE_FILE_LINE_NUMS_STRIPPED -> "IMAGE_FILE_LINE_NUMS_STRIPPED"
  | IMAGE_FILE_LOCAL_SYMS_STRIPPED -> "IMAGE_FILE_LOCAL_SYMS_STRIPPED"
  | IMAGE_FILE_AGGRESSIVE_WS_TRIM -> "IMAGE_FILE_AGGRESSIVE_WS_TRIM"
  | IMAGE_FILE_LARGE_ADDRESS_AWARE -> "IMAGE_FILE_LARGE_ADDRESS_AWARE"
  | RESERVED -> "RESERVED"
  | IMAGE_FILE_BYTES_REVERSED_LO -> "IMAGE_FILE_BYTES_REVERSED_LO"
  | IMAGE_FILE_32BIT_MACHINE -> "IMAGE_FILE_32BIT_MACHINE"
  | IMAGE_FILE_DEBUG_STRIPPED -> "IMAGE_FILE_DEBUG_STRIPPED"
  | IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP -> "IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP"
  | IMAGE_FILE_NET_RUN_FROM_SWAP -> "IMAGE_FILE_NET_RUN_FROM_SWAP"
  | IMAGE_FILE_SYSTEM -> "IMAGE_FILE_SYSTEM"
  | IMAGE_FILE_DLL -> "IMAGE_FILE_DLL"
  | IMAGE_FILE_UP_SYSTEM_ONLY -> "IMAGE_FILE_UP_SYSTEM_ONLY"
  | IMAGE_FILE_BYTES_REVERSED_HI -> "IMAGE_FILE_BYTES_REVERSED_HI"
  | UNKNOWN x -> Printf.sprintf "UNKNOWN_CHARACTERISTIC 0x%x" x

let is_dll characteristics =
  let characteristic = characteristic_to_int IMAGE_FILE_DLL in
  characteristics land characteristic = characteristic
