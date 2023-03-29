import 'dart:io';
import '../inputs/structs.dart';
import '../projection/utils.dart';

const header = '''
/**
 * Copyright (c) 2020 the Dart project authors. All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// struct_sizes.cpp

// Development utility to confirm the width of various Win32 structs.

// This code not used by the package itself, but is just a helper to inspect
// widths across x86 and x64 architectures. The results are pasted into
// win32\\struct_sizes.dart as input to the test harness.

// Compile with:
//    cl /I "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.19041.0\\winrt" \\
//      tool\\utils\\struct_sizes.cpp

#include <stdlib.h>
#include <winsock2.h>
#include <windows.h>
#include <stdio.h>
#include <ShlObj_core.h>
#include <netlistmgr.h>
#include <bluetoothapis.h>
#include <wincred.h>
#include <Shlwapi.h>
#include <physicalmonitorenumerationapi.h>
#include <CorHdr.h>
#include <DbgHelp.h>
#include <ShellScalingApi.h>
#include <AppxPackaging.h>
#include <dwmapi.h>
#include <wlanapi.h>
#include <SetupAPI.h>
#include <magnification.h>
#include <Xinput.h>

void main()
{
    // Manually generated structs
    printf("  'COR_FIELD_OFFSET': %zu,\\n", sizeof(COR_FIELD_OFFSET));
    printf("  'DECIMAL': %zu,\\n", sizeof(DECIMAL));
    printf("  'DEVMODE': %zu,\\n", sizeof(DEVMODEW));
    printf("  'GUID': %zu,\\n", sizeof(GUID));
    printf("  'MMTIME': %zu,\\n", sizeof(MMTIME));
    printf("  'OVERLAPPED': %zu,\\n", sizeof(OVERLAPPED));
    printf("  'PRINTER_NOTIFY_INFO_DATA': %zu,\\n", sizeof(PRINTER_NOTIFY_INFO_DATA));
    printf("  'PROCESS_HEAP_ENTRY': %zu,\\n", sizeof(PROCESS_HEAP_ENTRY));
    printf("  'PROPVARIANT': %zu,\\n", sizeof(PROPVARIANT));
    printf("  'SYSTEM_INFO': %zu,\\n", sizeof(SYSTEM_INFO));
    printf("  'VARIANT': %zu,\\n", sizeof(VARIANT));

    // Automatically generated structs
''';

const footer = '''
}
''';

void generateStructSizeAnalyzer() {
  final buffer = StringBuffer()..write(header);

  for (final struct in structsToGenerate.keys) {
    final cStructName = lastComponent(struct);
    final dartStructName = stripAnsiUnicodeSuffix(cStructName);
    buffer.write(
        '    printf("  \'$dartStructName\': %zu,\\n", sizeof($cStructName));\n');
  }

  buffer.write(footer);

  File('tool/utils/struct_sizes.cpp').writeAsStringSync(buffer.toString());
}
