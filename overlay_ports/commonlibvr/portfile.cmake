vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Raezroth/CommonLibVR-SkyMP
    REF de1061c5a6b480e0fa6ec343cf3ce1e32868e9d4
    SHA512 853fc6d041e4e6031bafb4fd86aa00c29e788bb1ecfb51fe8ed606a4a32b644fd0b99481fe80ebb84fe31a5a93da9aef264c381e7955922a89e9056c7fb7a8fb
    HEAD_REF master
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/include" DESTINATION "${CURRENT_PACKAGES_DIR}")
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
