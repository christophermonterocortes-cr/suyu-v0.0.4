# SPDX-FileCopyrightText: 2020 yuzu Emulator Project
# SPDX-License-Identifier: GPL-2.0-or-later

function(copy_suyu_FFmpeg_deps target_dir)
    include(WindowsCopyFiles)
    set(DLL_DEST "$<TARGET_FILE_DIR:${target_dir}>/")
    if (EXISTS "${FFmpeg_PATH}/requirements.txt")
        file(READ "${FFmpeg_PATH}/requirements.txt" FFmpeg_REQUIRED_DLLS)
        string(STRIP "${FFmpeg_REQUIRED_DLLS}" FFmpeg_REQUIRED_DLLS)
        windows_copy_files(${target_dir} ${FFmpeg_LIBRARY_DIR} ${DLL_DEST} ${FFmpeg_REQUIRED_DLLS})
    elseif (EXISTS "${FFmpeg_PATH}/bin")
        file(GLOB FFmpeg_DLLS RELATIVE "${FFmpeg_PATH}/bin" "${FFmpeg_PATH}/bin/*.dll")
        if (FFmpeg_DLLS)
            windows_copy_files(${target_dir} "${FFmpeg_PATH}/bin" ${DLL_DEST} ${FFmpeg_DLLS})
        endif()
    endif()
endfunction(copy_suyu_FFmpeg_deps)
