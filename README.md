# WantedlyChallenge

## 概要

Wantedly Summer Intern のiOSコースの選考課題です  

<img src="Doc/SampleSearch.gif" width = 40%><img src="Doc/SamplePagination.gif" width = 40%>


## 開発環境

XCode11.5, Swift5.2.4

## SetUp

```
make setup
```

ReactorKitをCarthageで入れているのでインストールのコマンドは  
makeにまとめてあります

## アーキテクチャ

ReatorKit(Flux)を使用しました。  
個人的に慣れてるのもありますが、軽量であることとFluxを分かりやすく  
落とし込んでいるのが良いと思って採用しています。

また具体的な画面遷移をRouterに投げることで分離しました。

## 使用ツール

- Carthage
  - ビルド速度の速さで採用しました。  

## 使用しているライブラリ

- ReactorKit 
  - アーキテクチャに使用

 - RxSwift
   - ReactorKitの依存先、かつリアクティブなプログラミングのために使用

- SDWebImage 
  - 画像の読み込みに使用
  - 使い慣れているから、パフォーマンス的な問題があればより性能の高いNukeに変更する予定でした。
- Swinject 
  - DIの為に使用
  - 依存先が別なものに依存している場合のスマートな実装が思いつかなかったので素直に採用しました。

- Moya/RxMoya
  - 通信に使用
  - 今まで使ったことがなかったので使ってみました。AssociatedTypeによりMoyaProviderでのDIができなかったのは微妙でしたが、それ以外は楽だと思いました。

- DiffableDataSources
  - TableView/CollectionViewのDataSourceとして使用
  - iOS13から使えるDiffabledDataSourceとほとんど同じ  
  かつパフォーマンスも高いのもあり採用しました。  
  CellItemをHashableに準拠しないといけないので親のReactor内で  
  子のReactorを作ってbindするというのは難しくなってしまうのと、  
  大きなEntityだとhashValueの計算により、目に見えてパフォーマンスが落ちてしまうのが問題と感じました。

## 工夫した点

- 募集の詳細をAPIから取れなかったので募集一覧をKVS的な手法で保持して、  
そこからIDで検索して取得することで画面遷移でentityを渡さずにidだけで  
済むようになりました

- ダークモードに対応しました。

- デザイン面ではWantedlyのイメージからそこまで丸みは持たせなくしたのと、  
役職とタイトルを前面に持ってくるようにしました。仕事を探している人にとっては役職と何をするのかが一番重要だと考えたからです。

- 設計面は可能な限りProtocol Orientedにして抽象に依存するようにしました。  
またViewControllerの責務を考えた際にライフサイクルに則り、適切なオブジェクトを生成し管理することだと考えたので、VCにおいてはカスタムViewの生成、Reactorの受け渡し、画面遷移、NavigationBarのコントロールに限定しました。

## 追記
心残りだった、Mint, Xcodegen, swiftlint, swiftformatを導入
