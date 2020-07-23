require 'rails_helper'

RSpec.describe "メッセージ投稿機能", type: :system do
  before do
   @room_user = FactoryBot.create( :room_user )
  end

  context "投稿に失敗したとき" do
    it "送る値が空の為、メッセージの送信に失敗すること" do
      # サインインする
      sign_in( @room_user.user )
      # 作成されたチャットルームへ遷移する
      click_on( @room_user.room.name )
      # DBに保存されてないこと
      expect {
        find( 'input[ name = "commit" ]' ).click
      }.not_to change { Message.count }
      # 元のページに戻ってくること
      expect( current_path ).to eq room_messages_path( @room_user.room )
    end
  end

  context "投稿に成功した時" do
    it "テキストの投稿に成功すると、投稿一覧に遷移して、投稿した内容が表示されている" do
      # サインインする
      sign_in( @room_user.user )
      # 作成されたチャットルームへ遷移する
      click_on( @room_user.room.name )
      # 値をテキストフォームに入力する
      post = "test"
      fill_in "message_content", with: post
      # 送信した値がDBに保存されていること
      expect {
        find( 'input[ name = "commit" ]' ).click
      }.to change { Message.count }.by( 1 )
      # 投稿一覧画面に遷移すること
      expect( current_path ).to eq room_messages_path( @room_user.room )
      # 送信した値がブラウザに表示されていること
      expect( page ).to have_content( post )
    end

    it "画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている" do
      # サインインする
      sign_in( @room_user.user )
      # 作成されたチャットルームへ遷移する
      click_on( @room_user.room.name )
      # 添付する画像を定義する
      image_path = Rails.root.join( "public/images/test_image.png" )
      # 画像選択フォームに画像を添付する
      attach_file( "message_image", image_path, make_visible: true )
      # 送信した値がDBに保存されていること
      expect {
        find( 'input[ name = "commit" ]' ).click
      }.to change { Message.count }.by( 1 )
      # 投稿一覧画面に遷移する
      expect( current_path ).to eq room_messages_path( @room_user.room )
      # 送信した画像がブラウザに表示されていること
      expect( page ).to have_selector( "img" )
    end

    it "テキストと画像の投稿に成功すること" do
      # サインインする
      sign_in( @room_user.user )
      # 作成されたチャットルームへ遷移する
      click_on( @room_user.room.name )
      # 添付する画像を定義する
      image_path = Rails.root.join( "public/images/test_image.png" )
      # 画像選択フォームに画像を添付する
      attach_file( "message_image", image_path, make_visible: true )
      # 値をテキストフォームに入力する
      post = "test"
      fill_in "message_content", with: post
      # 送信した値がDBに保存されていること
      expect {
        find( 'input[ name = "commit" ]' ).click
      }.to change { Message.count }.by( 1 )
      # 送信した値がブラウザに表示されていること
      expect( page ).to have_content( post )
      # 送信した画像がブラウザに表示されていること
      expect( page ).to have_selector( "img" )
    end

    it "チャットルームを削除すると、関連するメッセージが全て削除されていること" do
      # サインインする
      sign_in( @room_user.user )
      # 作成されたチャットルームに遷移する
      click_on( @room_user.room.name )
      # メッセージ情報を５つDBに追加する
      FactoryBot.create_list( :message, 5, room_id: @room_user.room.id, user_id: @room_user.user.id )
      # 「チャットを終了する」ボタンをクリックすることで、作成した５つのメッセージが削除する
      expect {
        find_link( "チャットを終了する", href: room_path( @room_user.room ) ).click
      }.to change { @room_user.room.messages.count }.by( -5 )
      # ルートページに遷移する
      expect( current_path ).to eq root_path
    end
  end
end
