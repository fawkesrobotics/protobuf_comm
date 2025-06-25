^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package protobuf_comm
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

0.9.3 (2025-06-25)
------------------
* prepare for ROS release

0.9.2 (2024-04-05)
------------------
* Merge pull request `#3 <https://github.com/fawkesrobotics/protobuf_comm/issues/3>`_ from fawkesrobotics/tviehmann/client-disconnect-fix
  client: disconnect only if not cancelled explicitly
* bump version
* client: disconnect only if not cancelled explicitly
* Contributors: Tarik Viehmann

0.9.1 (2023-11-01)
------------------
* bump version
* buildkite: switch to f38
* client: add function to check for outbound msgs
* Merge pull request `#1 <https://github.com/fawkesrobotics/protobuf_comm/issues/1>`_ from pkohout/main
  Lower minimum cmake version to 3.10.2
* Update minimum cmake version to 3.10.2 to be able to build with default melodic setup.
* Add buildkite pipeline
* Contributors: Tarik Viehmann, Till Hofmann, pkohout

0.9.0 (2021-06-27)
------------------
* Ignore compile_commands.json
* Generate pkgconfig file
* Set SOVERSION to the project's major version
* Export and install cmake package files
* Add cmake install target
* Add CMakeLists.txt to build the project
* Remove old Makefile
* Move header files into include/
* Add LICENSE file
* Import protobuf_comm from fawkes without modifications
* Initial commit
* Contributors: Till Hofmann
