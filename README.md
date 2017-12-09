# CoreKit

Ultimate cross platform framework to create appleOS apps.


### Dependencies

* SwiftLint v0.23.1+


### Swift Package Manager

```bash
swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.12"
```

### Warning: development in progress, here is a small todo list:

* CGPDFPage+DrawContext it's not really good inside CG
* TimeZoneLocation + Sun should be rewritten from the ground (moon additions)
* Server + Request + Response complete refactor?!?
* SKCircularProgressView not working on macOS (check uibezierpath)
* AppleImage+Vector is not supported on macOS
* AppleImage+Effects is not supported on macOS, SwiftLint
* AppleViewController+Alert check & move extension to AppleAlertControllerAlert
* AppleViewController extensions are iOS + tvOS only right now
* Explicit scrollView delegate for CollectionView
* Rework collectionViewSource



Enjoy. ;)


### License

[WTFPL](LICENSE)
