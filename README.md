# TagIt

- 처음에 예제를 이것저것 찾아보다가 스토리보드를 사용한 코드와 사용하지 않은 코드를 보면서 어떤 것을 사용할까 고민하고 두 방식을 섞어서 사용을 해봤지만, 나중에 협업을 하게 되는 경우 매운 안 좋은 것이니 지양하고 한 가지 스타일로 통일하여 개발을 하는 것이 좋다고 함
  - 확실히 스토리보드를 사용하면 UI가 어떻게 이뤄지는지 볼 수 있어서 좋은 반면, 스토리보드 작업물들을 다시 코드로 바꿔주는 작업으로 인해 빌드 속도가 늦어진다고 한다
  - 하지만 코드로만 UI를 구성하게 되면 스토리보드를 사용한 경우에 비해서 빠르게 빌드를 할 수 있다고 하지만, 눈에 보여지는 UI가 없어서 한 번에 어떻게 구성되는지 알아보기 힘들다는 단점이 있다
  - 두 가지 방법 다 잘하면 좋을 것 같다

## 기능 구현 참고 사항

### Photos Framework / fetch images

- [Photos Framework 사용 사진 갤러리 앱 애플 예제](https://developer.apple.com/library/archive/samplecode/UsingPhotosFramework/Introduction/Intro.html#//apple_ref/doc/uid/TP40014575-Intro-DontLinkElementID_2)

- https://zeddios.tistory.com/614

- https://zeddios.tistory.com/620

- https://zeddios.tistory.com/626

- [requestImage(for:targetSize:contentMode:options:resultHandler) 애플 문서](https://developer.apple.com/documentation/photokit/phimagemanager/1616964-requestimage)

  - 이 메소드를 호출하면 resultHandler에 UIImage가 담겨온다. 이 메소드는 사진 앱에서 asset이미지를 로드하거나 생성하는데, 그런 다음 resultHandler블록을 호출하여 요청된 이미지를 제공한다.

  - 요청을 보다 신속하게 처리하기위해, 이미지는 이미 캐시되어있거나, 더 효율적으로 생성 될 수 있기 때문에 targetSize보다 약간 큰 이미지를 제공 할 수 있다

  - **기본적으로 이 메소드는 비동기적으로 실행되고, 백그라운드 스레드에서 호출하는 경우, options파라미터의 isSynchronous프로퍼티를 true로 변경하여, 요청한 이미지가 준비되거나 오류가 발생 할 때 까지 calling thread(호출 쓰레드)를 차단 할 수도 있다.**

    - **비동기 요청의 경우**, Photos는 resultHandler블록을 두 번 이상 호출 할 수 있다. Photos는 먼저 블록을 호출하여 고품질 이미지를 준비하는 동안, 일시적으로 표시하기에 적합한 저품질 이미지를 제공한고, 품질이 낮은 이미지 데이터를 즉시 사용 할 수 있는 경우 메소드가 반환되기 전에 첫 번째 호출이 발생 할 수 있다.

    - 고품질 이미지가 준비되면, Photos에서는 resultHandler를 다시 호출하여 이를 제공한다. ImageManager가 이미 요청한 이미지를 최고 품질로 캐시한경우, Photos에서는 resultHandler를 한번만 호출한다

    - resultHandler의 info 파라미터에 있는 "PHImageResultIsDegradedKey" key는 Photos가 일시적인 저품질 이미지를 제공하는 시기를 제공한다

- [간략하게 정리해놓은 곳](https://medium.com/@audrl1010/photos-framework-a92c92ff3c74)

- prefetching 더 빨리, 스크롤 더 빨리 부드럽게 할 수 있는 방법 찾기

  - 일단 상욱이형이 추천해준 방식, 애플 사진 앱 실행해보면서 이런 방식이지 않을까한 방식으로 구현해서 잘 된다
  - **스크롤이 빨라질 때 딜레이가 생기는 문제이기 때문에, 스크롤 속도를 구해서 딜레이 생기는 속도 지점에서는 requestImage targetSize를 많이 줄여서 받아와서 딜레이를 줄이고, 이후에 스크롤이 정지를 한 순간에 다시 collectionView의 데이터를 다시 로드하는 방식으로 구현**
  - 애플 사진 앱은 동기 방식으로 이미지 가져오고, 카카오톡은 비동기 방식으로 이미지를 가져오는 것을 알 수 있었음
  - [스크롤이 멈추었는지 예측하는 코드 참고 링크](https://stackoverflow.com/questions/30582617/how-to-detect-when-a-uiscrollview-has-finished-scrolling-in-swift/30582692)
  - 애플 예제를 보다가 여기도 이미지를 빨리 가져오는데 prefetch 델리게이트 메소드를 굳이 사용하지 않았는데도, 이미지를 빨리 가져올 수 있어서 다른 방식으로 구현해봤음. 그리고 실제 앱에서도 이렇게 되는 것 같아서 해봤는데 잘 됐음
  - 애플 예제는 prefetch를 하지 않고, 스크롤 속도를 통해서 다른 처리 없이 캐싱만으로 해결을 한 거일 수도 있고, 안 한 것일 수 있는데 ==> 이후에 prefetch를 사용하는 경우([prefetch collectionView cell 애플예제 분석](https://developer.apple.com/documentation/uikit/uicollectionviewdatasourceprefetching/prefetching_collection_view_data)), 그냥 이렇게 캐싱만 사용하는 경우를 공부해서 장단점과 적절한 사용 예제를 정리해볼 것

- ```swift
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let asset = fetchResult.object(at: indexPath.item)
          
          // Dequeue a GridViewCell.
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoItemCell.self), for: indexPath) as? PhotoItemCell else {
              fatalError("unexpected cell in collection view")
          }
          
          cell.representedAssetIdentifier = asset.localIdentifier
  
          self.imageManager.requestImage(for: asset, targetSize: self.thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
              if cell.representedAssetIdentifier == asset.localIdentifier {
                  cell.thumbnailImage = image
              }
          })
          
          return cell
      }
      
      func checkScrollViewSpeed(_ scrollView: UIScrollView){
          let currentOffset = scrollView.contentOffset
          let currentTime = NSDate().timeIntervalSinceReferenceDate
          let timeDiff = currentTime - lastOffsetCapture!
          let captureInterval = 0.1
          
          if timeDiff > captureInterval {
              let distance = currentOffset.y - lastOffset!.y     // calc distance
              let scrollSpeedNotAbs = (distance * 10) / 1000     // pixels per ms*10
              let scrollSpeed = fabsf(Float(scrollSpeedNotAbs))  // absolute value
              
              if scrollSpeed > 10.0 {
                  isScrollingFast = true
              } else {
                  isScrollingFast = false
              }
              
              lastOffset = currentOffset
              lastOffsetCapture = currentTime
          }
      }
      
      // MARK: UIScrollView
      
      func scrollViewDidScroll(_ scrollView: UIScrollView) {
          updateCachedAssets()
          checkScrollViewSpeed(scrollView)
          
          if isScrollingFast {
              thumbnailSize = CGSize(width: cellSize.width * 0.5, height: cellSize.height * 0.5)
          }
      }
      
      func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
          thumbnailSize = CGSize(width: cellSize.width, height: cellSize.height)
          collectionView.reloadData()
      }
      
      func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
          perform(#selector(self.actionOnFinishedScrolling), with: nil, afterDelay: Double(velocity.x))
      }
      
      @objc func actionOnFinishedScrolling() {
          thumbnailSize = CGSize(width: cellSize.width, height: cellSize.height)
          collectionView.reloadData()
      }
  ```

### ScrollView

- 지금은 조금 미루는데, 아직 photo scroll할 때 이미지를 가운데로 가져와주는 기능이 안 되서 약간 부자연스러움
- 이후에 스크롤뷰에 관한 공부 더 할 것
- [페이지 뷰 컨트롤러 사용 및 스크롤 뷰로 확대 이미지 보기](https://www.raywenderlich.com/560-uiscrollview-tutorial-getting-started)

### UIGestureRecognizer

- https://stackoverflow.com/questions/29298567/allow-both-single-tap-gesture-recognizer-and-double-tap-in-uiscrollview/29299488
- https://guides.codepath.com/ios/Using-Gesture-Recognizers
- http://minsone.github.io/mac/ios/uigesturerecognizer
- https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/coordinating_multiple_gesture_recognizers/preferring_one_gesture_over_another
- 제스처 지정 및 PageViewController indicator 안 보이게 설정

  - singleTapGesture로 NavigationBar 및 ToolBar 안 보이게 설정
  - 기존의 doubleTapGesture가 singleTapGesture랑 곂쳐서 동작하지 않도록 설정
  - swipe down 제스처 추가하여 뒤로 가기 기능 구현. navigation controller이기 때문에 현재 view에 animation을 변형해서 사용. 인스타그램 swipe down 기능 참고하여 구현

### Search 기능

- 이미지 검색으로 이동하는 버튼 추가
  - UBER 검색 UI 참고하여, 사진 검색 기능으로 이동하기 위한 collectionView 위에 겹쳐진 버튼 추가
  - 아래로 내리는 제스처(⬇️) 동안에는 위로 움직이면서 사라져있다가, 위로 올리는 제스처(⬆️) 동안에는 다시 위에서 내려오는 애니메이션 구현해보기
  - segue 이동까지만 구현
- 일단 이렇게 구현한 UI는 이미지 컬렉션 뷰 위에 띄워져있기 때문에 overlay 돼서 원치 않는 사람들이 있을 것 같아서 우측상단 네비게이션 바에 검색 아이콘을 누르면 present modally로 검색 화면이 뜨게 구현했음
- ==> 추후 개선 사항은 검색 아이콘을 누르면 검색창이 이미지 컬렉션 뷰 위에 떠서(맥북 spotlight처럼) 이미지를 검색할 수 있게 구현할 예정

### SemiModalTransition

- https://github.com/usagimaru/SemiModalTransition
- 태그 추가하는 화면인 SemiModalPresentationController 추가
  - 태그 추가하기를 누르면 나오는 화면을 다 채우지 않는 view controller 추가
  - 그냥 half modal present와 다른 점은 이 반쯤만 나온 view 내부에서 navigation 이동을 할 수 있다는 점. 그리고 각 navigation controll view 내용 크기에 맞춰서 화면에 보여줄 수 있음
  - 일단은 태그만 추가하는 기능으로 만들지만, 이후에 태그 추가 및 색깔 설정까지 할 수 있게 할 예정이라 이 방식을 차용함
  - 맨 처음 PhotoViewController에서 검색 버튼을 스크롤을 올리면 사라지고, 내리면 보이게 설정. 애니메이션은 추가하지 않음
- ==> 이미지마다 색깔 태그를 가질 수 있게 구현. 데이터베이스 작업 남음

### 데이터 전달

- ColorPickerViewController에서 고른 색깔을 TaggingViewController TableView에 표시할 때 델리게이트 사용
- TaggingViewController에서 태그 추가 완료하고 다시 이미지 보기로 돌아갈 때 ZoomedPhotoViewController에 Unwind 사용

### Realm

- [Realm](http://realm.io/) is a cross-platform mobile database solution designed for mobile applications that you can integrate with your iOS projects. Unlike wrappers around Core Data, Realm doesn’t rely on Core Data or even an SQLite back end.
- 이미지 저장할 때

## Todo

- 스터디 프로젝트 사진 검색 애플리케이션 Tag It
  - ScrollView 공부
    - 처음은 흰색 배경에 위아래 탭바, 터치 제스쳐 한 번 누르면 검은 배경만, 그 다음은 복귀 반복
    - 이미지가 완전히 중앙에 오도록 해보기
    - autolayout 적용시 주의 사항
    - https://iamprgrmr.tistory.com/30
    - https://stackoverflow.com/questions/19036228/uiscrollview-scrollable-content-size-ambiguity
  - 이미지 캐싱 이슈 분석 및 정리하기
    - [collectionView prefetch apple example](https://developer.apple.com/documentation/uikit/uicollectionviewdatasourceprefetching/prefetching_collection_view_data)
    - [photos framework apple example](https://developer.apple.com/library/archive/samplecode/UsingPhotosFramework/Introduction/Intro.html#//apple_ref/doc/uid/TP40014575-Intro-DontLinkElementID_2)
  - 코드 리팩토링 / Manager, Collection, Handler의 차이에 대해서 알아보기
  - 권한 문제: 맨 처음 받아오면 이미지 갯수 0으로 되고, 다시 이미지 띄워주지 못하는 이슈
  - 이미지 상세 보기 한 번 클릭하면 navigation bar / tool bar 사라지고, 다시 한 번 더 누르면 나타나기 기능 추가
  - 태그 추가 기능 realm DB 연동 및 다른 DB와 비교 정리
  - 선택 / 공유 / 삭제 기능
  - 동영상 재생 기능 / 앨범에 따라 이미지를 가져올 수 있게 구현
  - 태그 추가된 이미지는 컬렉션 뷰에서 태그 표시 해주기

- 코드 필요하면 참고

  ```swift
  if let dirPath        = paths.first {
      let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("IMG_0033.JPG")
      let image    = UIImage(contentsOfFile: imageURL.path)
  
      PhotographManager.sharedInstance.PHAssetForFileURL(url: imageURL)
      print("### TEST ")
      print(PhotographManager.sharedInstance.PHAssetForFileURL(url: imageURL))
      //Users/jaehyukshin/Library/Developer/CoreSimulator/Devices/31107B78-97FF-4F71-B16E-C0BE4F41786B/data/Media/DCIM/100APPLE/IMG_0047.JPG
  }
  ```

  ```swift
  let photograph: Photograph = Photograph(name: "IMG_0033.JPG", localIdentifier: "69676321-F746-4F2C-9489-07522BA9EBC5/L0/001", colorId: "FDA293", tagArray: ["신발", "패션"])
  RealmManager.sharedInstance.saveObjects(object: photograph)
  print(RealmManager.sharedInstance.getObjects(type: Photograph.self))
  ```

- 