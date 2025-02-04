🎞️ Moviegram
=============
Moviegram은 다양한 영화의 정보를 조회하고 나만의 보관함에 저장할 수 있는 어플리케이션입니다.

## ✔️ 대표 기능
1. 영화의 정보를 **검색**할 수 있습니다. (줄거리, 출연진, 장르 등)
2. 보관함에 영화를 **보관**할 수 있습니다.

## ✔️ 기술 스택
- UIKit (codebase)
- Snapkit
- Kingfisher
- Alamofire
- Storyboard (런치 스크린)

## ✔️ 기술 설명
### UserDefaults
`싱글톤 패턴`과 `프로퍼티 옵저버`를 사용하여 사용자의 여러 정보를 한 곳에서 관리하도록 하였습니다.   
(프로필 이미지, 닉네임, 가입날짜, 영화 보관 정보 등)


### ViewController의 loadView 최적화
Viewcontroller에서 매번 View를 생성하여 로드하지 않고,   
상속 받고 있는 BaseViewController에서 `Generic`을 활용하여 View를 설정할 수 있도록 하였습니다.   

### Generic을 활용한 네트워크 함수 최적화
Alamofire를 사용한 네트워크 처리 함수에서 데이터 타입 파라미터를 `Generic` 타입으로 받음으로써, 다양한 데이터 타입에 대해서 동일한 네트워크 함수 코드를 `재사용`할 수 있도록 하였습니다.


### Delegate 패턴을 통해 앱 전역에서 데이터 업데이트
여러 화면에 분포되어 있는 좋아요 버튼의 데이터 업데이트 처리를하기 위해 Delegate 패턴을 사용하였습니다.   
좋아요 버튼의 액션과 데이터 처리를 Delegate를 채택하고 있는 화면에서 사용할 수 있고 모든 화면에서 동기화될 수 있도록 하였습니다.

## ✔️ 트러블슈팅
### [문제 1]
화면 전환 시 모든 네비게이션바의 backButtonTitle을 없애기 위해, BaseViewController의 viewDidLoad에서 해당 코드를 작성했지만 적용되지 않았습니다.   

#### 원인 분석:
```
let vc = MovieDetailViewController()
navigationController?.pushViewController(vc, animated: true)
```
새로운 화면을 생성하고 navigationController에 push하기 전에 backButtonTitle 설정 코드가 작성된 viewDidLoad가 이미 실행이 되고 있습니다.   
따라서, 네비게이션바가 생성이 되기 전에 해당 코드가 실행이 되기 때문에, 작성한 코드가 작동하지 않음을 깨달았습니다.

#### 해결:
위의 원인 분석에서 네비게이션바가 생성되고 난 후에, 해당 코드를 실행시켜야 된다는 것을 알게 되어   
BaseViewController의 viewWillAppear에 backButtonTitle을 설정함으로써 문제를 해결하였습니다.


### [문제 2] 
UITableViewCell에서 버튼의 액션이 작동하지 않았습니다.

#### 원인 분석
<img width="500" alt="스크린샷 2025-02-04 오후 11 09 15" src="https://github.com/user-attachments/assets/877e318d-250f-4f47-8bd1-bac46699a294" />
<img width="310" alt="스크린샷 2025-02-04 오후 11 10 55" src="https://github.com/user-attachments/assets/cd2a4ebb-5703-4cbc-8440-5ea33c4bb566" />

View Hierarchy를 통해 확인한 결과, 셀에 추가한 뷰 위에 contentView가 덮어씌워져 있는 것을 확인하였습니다.     
애플 공식 문서에 따르면, addSubview는 부모 뷰의 하위 뷰 목록의 끝에 뷰를 추가하는 메서드입니다.   
따라서, contentView를 생략하고 addSubview를 하였기 때문에, cell 자체의 하위뷰로 추가되어 버튼의 액션이 contentView에 가려져 해당 문제가 발생함을 알게되었습니다.
(contentView의 하위뷰가 아닌, contentView와 같은 계층으로 추가된 것을 확인)   

#### 해결
contentView 자체에 addSubview 메서드를 실행하여 해결하였습니다.

## ✔️ 회고
조건 검사 로직을 짜면서, `시간 복잡도`에 대한 고민과 로직을 언어로 옮길 수 있는 `swift 문법` 지식에 대한 필요성을 느꼈습니다.   
또한, 복잡한 기능의 경우에는 개발 로직을 `문서로 정리`하여 추후 기능이 추가되거나 변경될 때를 대비하고 자신이 작성한 코드에 대해 명확하게 설명할 수 있어야 함을 느꼈습니다.

개발기간 (2025.01.24 - 2025.02.01)
