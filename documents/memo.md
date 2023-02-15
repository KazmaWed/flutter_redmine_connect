### Sequence

#### Flutter WebアプリでRedmine APIを利用してチケットを作成

@import "sequence.puml"

- Firebase_Authの認証を利用し、アプリの操作とGASの実行を制限
- 認証にはRedmineのID/PWまたはGoogleを利用
  (新規作成が不要かつ管理しやすいもの)
- Redmine API KeyはGAS内に格納し、アプリからは隠蔽