class UsersController < ApplicationController

  def edit
  end

  def update
    if current_user.update( user_params )       #user_paramsの値をアップデートしたら
      redirect_to root_path                     #ルート(チャット画面)へ リダイレクト
    else
      render :edit                              #edit(名前編集画面)に戻る
    end
  end

  private

  def user_params
    params.require( :user ).permit( :name, :email )   #ユーザー情報 名前 メールアドレス取得
  end

end
