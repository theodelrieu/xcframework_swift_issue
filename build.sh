rm -rf c_lib/Add.xcframework c_lib/build-macos c_lib/build-ios swi

mkdir c_lib/build-macos && pushd c_lib/build-macos
clang -c ../add.c -I ../include -o add.o
ar -c -r libadd.a add.o
popd

mkdir c_lib/build-ios && pushd c_lib/build-ios
clang -arch arm64 -isysroot `xcrun --sdk iphonesimulator --show-sdk-path` -mios-simulator-version-min=10.0 -c ../add.c -I ../include -o add.o 
ar -c -r libadd.a add.o
popd

xcodebuild -create-xcframework -library c_lib/build-macos/libadd.a -headers c_lib/include -library c_lib/build-ios/libadd.a -headers c_lib/include -output c_lib/Add.xcframework

mkdir -p swift-add/swift-add/Frameworks && rm -rf swift-add/swift-add/Frameworks/Add.xcframework && cp -r c_lib/Add.xcframework swift-add/swift-add/Frameworks
mkdir -p objc-add/objc-add/Frameworks && rm -rf objc-add/objc-add/Frameworks/Add.xcframework && cp -r c_lib/Add.xcframework objc-add/objc-add/Frameworks
