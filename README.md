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
- prefetching

### ScrollView

- 지금은 조금 미루는데, 아직 photo scroll할 때 이미지를 가운데로 가져와주는 기능이 안 되서 약간 부자연스러움
- 이후에 스크롤뷰에 관한 공부 더 할 것
- [페이지 뷰 컨트롤러 사용 및 스크롤 뷰로 확대 이미지 보기](https://www.raywenderlich.com/560-uiscrollview-tutorial-getting-started)
- 

## Todo

- 스터디 프로젝트 사진 검색 애플리케이션 Tag It
  - ScrollView 공부
    - 처음은 흰색 배경에 위아래 탭바, 터치 제스쳐 한 번 누르면 검은 배경만, 그 다음은 복귀 반복
    - 이미지가 완전히 중앙에 오도록 해보기
    - autolayout 적용시 주의 사항
    - https://iamprgrmr.tistory.com/30
    - https://stackoverflow.com/questions/19036228/uiscrollview-scrollable-content-size-ambiguity
  - 권한 문제: 맨 처음 받아오면 이미지 갯수 0으로 되고, 다시 이미지 띄워주지 못하는 이슈
  - 이미지 캐싱 이슈: 상욱이형 코드 참고해서 어떤 방식으로 해결했는지 정리할 것
    - Photo관련 공부 및 정리
  - 코드 리팩토링 / 지금까지 한 것 정리
  - 페이지 뷰 컨트롤러 하단 dot 표시 인스타그램처럼 표시하기
  - 컬렉션뷰컨트롤러에서 뷰컨트롤러로 변경할 것
  - 검색 인터페이스 추가: 검색 텍스트필드 누르면 다른 화면으로 넘어가서 검색 기능 수행
  - 태그 추가 슬라이드 버톰 시트 추가
  - 태그 추가 기능 realm DB 연동 및 다른 DB와 비교 정리
  - 선택 기능, 공유 기능 추가