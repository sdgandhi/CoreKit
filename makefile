all:
	swift build

test:
	swift test

macOS:
	swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.12"

macOStest:
	swift test -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.12"

docker:
	docker-compose run corekit-swift bash

clean:
	rm -rf .build

lint:
	swiftlint autocorrect && swiftlint

