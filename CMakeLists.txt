cmake_minimum_required(VERSION 3.12)

project(protobuf_comm)

find_package(Protobuf REQUIRED)
find_package(Boost REQUIRED COMPONENTS thread system)

add_library(protobuf_comm SHARED client.cpp server.cpp peer.cpp crypto.cpp
                                 message_register.cpp)
target_link_libraries(protobuf_comm PUBLIC protobuf::libprotobuf Boost::boost
                                           Boost::thread Boost::system)
target_include_directories(protobuf_comm PUBLIC include)

file(GLOB PUBLIC_HEADER_FILES include/protobuf_comm/*.h)
set_target_properties(protobuf_comm PROPERTIES PUBLIC_HEADER
                                               "${PUBLIC_HEADER_FILES}")

find_package(OpenSSL COMPONENTS Crypto)
if(OPENSSL_FOUND)
  target_link_libraries(protobuf_comm PUBLIC OpenSSL::Crypto)
  target_compile_options(protobuf_comm PRIVATE "-DHAVE_LIBCRYPTO")
endif()

include(GNUInstallDirs)

install(
  TARGETS protobuf_comm
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/protobuf_comm)
