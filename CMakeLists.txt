cmake_minimum_required(VERSION 3.10.2)

project(protobuf_comm VERSION 0.9.3
  DESCRIPTION "Protobuf wrapper for peer-to-peer communication")

find_package(Protobuf REQUIRED)
find_package(Boost CONFIG REQUIRED COMPONENTS thread system)


add_library(protobuf_comm SHARED client.cpp server.cpp peer.cpp crypto.cpp
                                 message_register.cpp)
target_link_libraries(protobuf_comm PUBLIC protobuf::libprotobuf Boost::boost
                                           Boost::thread Boost::system)
target_include_directories(
  protobuf_comm PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>$<INSTALL_INTERFACE:include>)
set_target_properties(protobuf_comm PROPERTIES SOVERSION
                                               ${PROJECT_VERSION_MAJOR})

find_package(OpenSSL COMPONENTS Crypto)
if(OPENSSL_FOUND)
  target_link_libraries(protobuf_comm PUBLIC OpenSSL::Crypto)
  target_compile_options(protobuf_comm PRIVATE "-DHAVE_LIBCRYPTO")
endif()

include(GNUInstallDirs)

install(
  TARGETS protobuf_comm
  EXPORT ProtobufCommTargets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES DESTINATION include)

install(DIRECTORY include/protobuf_comm DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/ProtobufCommConfigVersion.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion)

install(
  EXPORT ProtobufCommTargets
  FILE ProtobufCommTargets.cmake
  NAMESPACE ProtobufComm::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/ProtobufComm)

install(FILES cmake/ProtobufCommConfig.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/ProtobufCommConfigVersion.cmake
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/ProtobufComm)

set(PKG_CONFIG_REQUIRES "protobuf libcrypto")
get_target_property(PKG_CONFIG_PUBLIC_LIBS protobuf_comm INTERFACE_LINK_LIBRARIES)
get_target_property(PKG_CONFIG_PRIVATE_LIBS protobuf_comm LINK_LIBRARIES)
get_target_property(PKG_CONFIG_CFLAGS protobuf_comm COMPILE_FLAGS)
if ("${PKG_CONFIG_CFLAGS}" STREQUAL "PKG_CONFIG_CFLAGS-NOTFOUND")
  set(PKG_CONFIG_CFLAGS "")
endif()

set(PKG_CONFIG_PUBLIC_LIBS "-lcrypto -lprotobuf -lboost_thread -lboost_system")
set(PKG_CONFIG_PRIVATE_LIBS "")
set(PKG_CONFIG_CFLAGS "")

configure_file(protobuf_comm.pc.in ${CMAKE_CURRENT_BINARY_DIR}/protobuf_comm.pc @ONLY)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/protobuf_comm.pc DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)
