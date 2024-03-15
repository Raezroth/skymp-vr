function(link_vcpkg_dependencies)
  cmake_parse_arguments(A "" "" "TARGETS" ${ARGN})
  foreach(arg TARGETS)
    if ("${A_${arg}}" STREQUAL "")
      message(FATAL_ERROR "Missing ${arg} argument")
    endif()
  endforeach()

  foreach(target ${A_TARGETS})
    if(MSVC)
      find_package(unofficial-chakracore CONFIG REQUIRED)
      target_link_libraries(${target} PUBLIC unofficial::chakracore::chakracore)
    endif()

    find_path(JSON_INCLUDE_DIR NAMES json.hpp PATH_SUFFIXES nlohmann)
    get_filename_component(JSON_INCLUDE_DIR ${JSON_INCLUDE_DIR} DIRECTORY)
    target_include_directories(${target} PUBLIC ${JSON_INCLUDE_DIR})

    find_path(HTTPLIB_INCLUDE_DIR NAMES httplib.h PATH_SUFFIXES include)
    get_filename_component(HTTPLIB_INCLUDE_DIR ${HTTPLIB_INCLUDE_DIR} DIRECTORY)
    target_include_directories(${target} PUBLIC ${HTTPLIB_INCLUDE_DIR})

    find_package(ZLIB REQUIRED)
    target_link_libraries(${target} PUBLIC ZLIB::ZLIB)

    find_path(MAKEID_INCLUDE_DIR NAMES MakeID.h)
    target_include_directories(${target} PUBLIC ${MAKEID_INCLUDE_DIR})

    if(MSVC AND "${target}" MATCHES "skyrim_platform_vr")
      find_library(MHOOH_LIBRARY_DEBUG mhook)
      string(REPLACE "/debug/lib/" "/lib/" MHOOH_LIBRARY_RELEASE ${MHOOH_LIBRARY_DEBUG})
      find_path(MHOOH_INCLUDE_DIR NAMES mhook.h PATH_SUFFIXES mhook-lib)
      target_link_libraries(${target} PUBLIC "$<IF:$<CONFIG:Debug>,${MHOOH_LIBRARY_DEBUG},${MHOOH_LIBRARY_RELEASE}>")
      target_include_directories(${target} PUBLIC ${MHOOH_INCLUDE_DIR})

      find_library(SKSEVR_LIBRARY_DEBUG sksevr)
      string(REPLACE "/debug/lib/" "/lib/" SKSEVR_LIBRARY_RELEASE ${SKSEVR_LIBRARY_DEBUG})
      find_path(SKSEVR_INCLUDE_DIR sksevr/PluginAPI.h)
      target_link_libraries(${target} PUBLIC "$<IF:$<CONFIG:Debug>,${SKSEVR_LIBRARY_DEBUG},${SKSEVR_LIBRARY_RELEASE}>")
      target_include_directories(${target} PUBLIC ${SKSEVR_INCLUDE_DIR})

      find_library(SKSEVR_COMMON_LIBRARY_DEBUG sksevr_common)
      string(REPLACE "/debug/lib/" "/lib/" SKSEVR_COMMON_LIBRARY_RELEASE ${SKSEVR_COMMON_LIBRARY_DEBUG})
      find_path(SKSEVR_COMMON_INCLUDE_DIR sksevr/PluginAPI.h)
      target_link_libraries(${target} PUBLIC "$<IF:$<CONFIG:Debug>,${SKSEVR_COMMON_LIBRARY_DEBUG},${SKSEVR_COMMON_LIBRARY_RELEASE}>")
      target_include_directories(${target} PUBLIC ${SKSEVR_COMMON_INCLUDE_DIR})

      find_library(COMMON_LIBRARY_DEBUG common)
      string(REPLACE "/debug/lib/" "/lib/" COMMON_LIBRARY_RELEASE ${COMMON_LIBRARY_DEBUG})
      find_path(COMMON_INCLUDE_DIR sksevr/PluginAPI.h)
      target_link_libraries(${target} PUBLIC "$<IF:$<CONFIG:Debug>,${COMMON_LIBRARY_DEBUG},${COMMON_LIBRARY_RELEASE}>")
      target_include_directories(${target} PUBLIC ${COMMON_INCLUDE_DIR})

      find_library(COMMONLIBVR_LIBRARY_DEBUG CommonLibVR)
      string(REPLACE "/debug/lib/" "/lib/" COMMONLIBVR_LIBRARY_RELEASE ${COMMONLIBVR_LIBRARY_DEBUG})
      find_path(COMMONLIBVR_INCLUDE_DIR SKSE/API.h)
      target_link_libraries(${target} PUBLIC "$<IF:$<CONFIG:Debug>,${COMMONLIBVR_LIBRARY_DEBUG},${COMMONLIBVR_LIBRARY_RELEASE}>")
      target_include_directories(${target} PUBLIC ${COMMONLIBVR_INCLUDE_DIR})

      # CommonLibVR requirement
      target_link_libraries(${target} PUBLIC Version)
      target_compile_options(${target} PUBLIC "/FI\"ForceInclude.h\"" "/FI\"SKSE/Logger.h\"")

      find_package(directxtk CONFIG REQUIRED)
      find_package(directxmath CONFIG REQUIRED)
      target_link_libraries(${target} PUBLIC Microsoft::DirectXTK)
    endif()

    if(MSVC AND "${target}" MATCHES "skyrim_platform")
      find_library(MHOOH_LIBRARY_DEBUG mhook)
      string(REPLACE "/debug/lib/" "/lib/" MHOOH_LIBRARY_RELEASE ${MHOOH_LIBRARY_DEBUG})
      find_path(MHOOH_INCLUDE_DIR NAMES mhook.h PATH_SUFFIXES mhook-lib)
      target_link_libraries(${target} PUBLIC "$<IF:$<CONFIG:Debug>,${MHOOH_LIBRARY_DEBUG},${MHOOH_LIBRARY_RELEASE}>")
      target_include_directories(${target} PUBLIC ${MHOOH_INCLUDE_DIR})

      if (SKYRIM_SE)
        find_package(commonlibse REQUIRED CONFIGS CommonLibSSEConfig.cmake)
      elseif(SKYRIM_AE)
        find_package(commonlibae REQUIRED CONFIGS CommonLibSSEConfig.cmake)
      elseif(SKYRIM_VR)
	      find_package(commonlibvr REQUIRED CONFIGS CommonLibVRConfig.cmake)
      endif()

      find_package(Boost MODULE REQUIRED)
      find_package(robin_hood REQUIRED)

      find_path(SIMPLEINI_INCLUDE_DIRS "ConvertUTF.c")
      target_include_directories(${target} PRIVATE ${SIMPLEINI_INCLUDE_DIRS})

      if(SKYRIM_AE)
      	target_link_libraries(${target}	PRIVATE	Boost::headers CommonLibSSE::CommonLibSSE robin_hood::robin_hood)
      else(SKYRIM_VR)
      	target_link_libraries(${target}	PRIVATE	Boost::headers CommonLibVR::CommonLibVR robin_hood::robin_hood)
      endif()

      find_package(directxtk CONFIG REQUIRED)
      find_package(directxmath CONFIG REQUIRED)
      target_link_libraries(${target} PUBLIC Microsoft::DirectXTK)
    endif()

    find_package(spdlog CONFIG REQUIRED)
    target_link_libraries(${target} PUBLIC spdlog::spdlog)

    find_package(OpenSSL REQUIRED)
    target_link_libraries(${target} PUBLIC OpenSSL::SSL OpenSSL::Crypto)

    find_package(bsa CONFIG REQUIRED)
    target_link_libraries(${target} PUBLIC bsa::bsa)
  endforeach()
endfunction()
