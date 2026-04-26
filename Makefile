generate:
	dart run build_runner build --delete-conflicting-outputs
buildapp:
	flutter build apk --split-per-abi
