include(CMakeFindDependencyMacro)
find_dependency(Protobuf)
find_dependency(Boost COMPONENTS thread system)
find_dependency(OpenSSL)
include("${CMAKE_CURRENT_LIST_DIR}/ProtobufCommTargets.cmake")
