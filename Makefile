generate:
	dart run build_runner build --delete-conflicting-outputs
build
	flutter build apk --split-per-abi
