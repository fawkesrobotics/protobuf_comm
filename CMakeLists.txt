cmake_minimum_required(VERSION 3.12)

project(protobuf_comm)

find_package(Protobuf REQUIRED)
find_package(Boost REQUIRED COMPONENTS thread system)
add_library(protobuf_comm SHARED client.cpp server.cpp peer.cpp crypto.cpp
                                 message_register.cpp)
target_link_libraries(protobuf_comm PUBLIC protobuf::libprotobuf Boost::boost
                                           Boost::thread Boost::system)
target_include_directories(protobuf_comm PUBLIC include)

find_package(OpenSSL COMPONENTS Crypto)
if(OPENSSL_FOUND)
  target_link_libraries(protobuf_comm PUBLIC OpenSSL::Crypto)
  target_compile_options(protobuf_comm PRIVATE "-DHAVE_LIBCRYPTO")
endif()
