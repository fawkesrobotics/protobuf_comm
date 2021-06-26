cmake_minimum_required(VERSION 3.12)

project(protobuf_comm VERSION 0.9.0)

find_package(Protobuf REQUIRED)
find_package(Boost REQUIRED COMPONENTS thread system)

add_library(protobuf_comm SHARED client.cpp server.cpp peer.cpp crypto.cpp
                                 message_register.cpp)
target_link_libraries(protobuf_comm PUBLIC protobuf::libprotobuf Boost::boost
                                           Boost::thread Boost::system)
target_include_directories(
  protobuf_comm PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)

find_package(OpenSSL COMPONENTS Crypto)
if(OPENSSL_FOUND)
  target_link_libraries(protobuf_comm PUBLIC OpenSSL::Crypto)
  target_compile_options(protobuf_comm PRIVATE "-DHAVE_LIBCRYPTO")
endif()

include(GNUInstallDirs)

install(
  TARGETS protobuf_comm
  EXPORT ProtobufCommTargets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

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
