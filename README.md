# GSProgressHUD

GSProgressHUD is a simple lightweight progress HUD based on [SVProgressHUD](https://github.com/samvermette/SVProgressHUD) for displaying information to the user.

## Get started

- [Download GSProgressHUD](https://github.com/GaSaMedia/GSProgressHUD/archive/master.zip)

#### Podfile

```ruby
platform :ios
pod "GSProgressHUD"
```

## Requirements

GSProgressHUD requires Xcode 4/5, targeting iOS 5.0 and above.

## Basic usage

#### Show GSProgressHUD in current view
```objective-c
[GSProgressHUD showImage:[UIImage imageNamed:@"check"] withStatus:@"Working..."];
```

#### Hide GSProgressHUD
```objective-c
if ([GSProgressHUD isVisible]) {
  [GSProgressHUD dismiss];
}
```

#### Pop (show/wait/hide) image with text
```objective-c
[GSProgressHUD popImage:[UIImage imageNamed:@"check"] withStatus:@"Working..."];
```

## Contact

Follow GaSa Media on Twitter [@gasamedia](https://twitter.com/gasamedia)

## License

GSProgressHUD is available under the MIT license. See the LICENSE file for more info.
